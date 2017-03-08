import Runes
import TryParsec


fileprivate func asExpr(expr: Expression) -> Expression {
    return expr
}

let expr = _expr(isBasic: false)
let exprBasic = _expr(isBasic: true)

func _expr(isBasic: Bool) -> SwiftParser<Expression> {
    return exprSequence(isBasic: isBasic)
}

func exprSequence(isBasic: Bool) -> SwiftParser<Expression> {
    return exprSequenceElement(isBasic: isBasic)
            >>- { lhs in binarySuffix(lhs: lhs, isBasic: isBasic) }
}

let binOp = oper_infix <|> oper_infix("as") <|> oper_infix("is") <|> oper_infix("=")

func binarySuffix(lhs: Expression, isBasic: Bool) -> SwiftParser<Expression> {
    let bin: SwiftParser<Expression> = { op in { rhs in
        BinaryOperation(leftOperand: lhs, operatorSymbol: op, rightOperand: rhs) }}
        <^> binOp <*> _expr(isBasic: isBasic)
    return (bin >>- { lhs in binarySuffix(lhs: lhs, isBasic: isBasic) })
        <|> pure(lhs)
}

func exprSequenceElement(isBasic: Bool) -> SwiftParser<Expression> {
    let parseTry
        = ({ _ in "try!" } <^> kw_try *> char("!") *> WS)
            <|> ({ _ in "try?" } <^> kw_try *> char("?") *> WS)
            <|> ({ _ in "try" } <^> kw_try *> WS)
            <|> pure(nil)
    return { op in { subExpr in
        op != nil ? PrefixUnaryOperation(operatorSymbol: op!, operand: subExpr) : subExpr }}
        <^> parseTry
        <*> exprUnary(isBasic: isBasic)
}

func exprUnary(isBasic: Bool) -> SwiftParser<Expression> {
    return { op in { subExpr in
        op != nil ? PrefixUnaryOperation(operatorSymbol: op!, operand: subExpr) : subExpr }}
        <^> zeroOrOne(oper_prefix)
        <*> exprAtom(isBasic: isBasic)
}

func exprAtom(isBasic: Bool) -> SwiftParser<Expression> {
    return exprPrimitive >>- exprSuffix(isBasic: isBasic)
}

//-----------------------------------------------------------------------
// primitive expressions

let exprPrimitive = _exprPrimitive()
func _exprPrimitive() -> SwiftParser<Expression> {
    return (exprStringLiteral <&> asExpr)
        <|> (exprFloatLiteral <&> asExpr)
        <|> (exprIntegerLiteral <&> asExpr)
        <|> (exprNilLiteral <&> asExpr)
        <|> (exprArrayLiteral <&> asExpr)
        <|> (exprDictionaryLiteral <&> asExpr)
        <|> (exprIdentifier <&> asExpr)
        <|> (exprSelf <&> asExpr)
        <|> (exprSuper <&> asExpr)
        <|> (exprParenthesized <&> asExpr)
        <|> (exprTuple <&> asExpr)
        <|> (exprImplicitMember <&> asExpr)
        <|> (exprWildcard <&> asExpr)
        <|> (exprClosure <&> asExpr)
}

let genericArgs = _genericArgs()
func _genericArgs() -> SwiftParser<[Type_]> {
    return list(char("<"), type, comma, char(">"))
}

let exprIdentifier = _exprIdentifier()
func _exprIdentifier() -> SwiftParser<IdentifierExpression> {
    return { ident in { generics in
        IdentifierExpression(identifier: ident) }}
        <^> (identifier <|> dollarIdentifier)
        <*> zeroOrOne(OWS *> genericArgs)
}

let exprSelf = _exprSelf()
func _exprSelf() -> SwiftParser<SelfExpression>  {
    return { _ in SelfExpression() } <^> kw_self
}

let exprSuper = _exprSuper()
func _exprSuper() -> SwiftParser<SuperclassExpression>  {
    return { _ in SuperclassExpression() } <^> kw_super
}

let exprClosure = _exprClosure()
func _exprClosure() -> SwiftParser<ClosureExpression>  {
    typealias Param = (String, Type_?)
    let name: SwiftParser<String> = (identifier <|> kw__)
    let nameParam: SwiftParser<Param> = name <&> { name in (name, nil) }
    let paramsName: SwiftParser<[Param]> = sepBy1(nameParam, OWS *> comma <* OWS)
    let paramsNameTuple: SwiftParser<[Param]> = list(l_paren, nameParam, comma, r_paren)

    let typedName: SwiftParser<Param> = { name in { ty in (name, ty) }} <^> name <*> (OWS *> colon *> OWS *> type)
    let paramsTyped: SwiftParser<[Param]> = list(l_paren, typedName, comma, r_paren)

    let sig = { args in { th in { ty in (args: args, hasThrows: th != nil, result: ty) }}}
        <^> (OWS *> (paramsName <|> paramsNameTuple <|> paramsTyped))
        <*> zeroOrOne(OWS *> kw_throws)
        <*> zeroOrOne(OWS *> arrow *> OWS *> type)
    
    return { sig in { body in
        ClosureExpression(
            arguments: sig?.args ?? [],
            hasThrows: sig?.hasThrows ?? false,
            result: sig?.result,
            statements: body) }}
        <^> l_brace
        *> zeroOrOne(sig <* OWS <* kw_in)
        <*> (OWS *> stmtBraceItems <* OWS <* r_brace)
}

let exprParenthesized = _exprParenthesized()
func _exprParenthesized() -> SwiftParser<ParenthesizedExpression>  {
    return { value in ParenthesizedExpression(expression: value) }
        <^> l_paren *> OWS *> expr <* OWS <* r_paren
}

let exprTuple = _exprTuple()
func _exprTuple() -> SwiftParser<TupleExpression>  {
    let element = { label in { value in (label, value) }}
        <^> zeroOrOne(keywordOrIdentifier <* OWS <* colon)
        <*> (OWS *> expr)
    
    return { elements in TupleExpression(elements: elements) }
        <^> list(l_paren, element, comma, r_paren)
 }

let exprImplicitMember = _exprImplicitMember()
func _exprImplicitMember() -> SwiftParser<ImplicitMemberExpression>  {
    return { ident in ImplicitMemberExpression() }
        <^> (period *> identifier)
}


let exprWildcard = _exprWildcard()
func _exprWildcard() -> SwiftParser<WildcardExpression> {
    return { _ in WildcardExpression() }
        <^> kw__
}

//-----------------------------------------------------------------------
// suffix expressions

func exprSuffix(isBasic: Bool) -> (Expression) -> SwiftParser<Expression> {
    return { subj in exprSuffix(subj: subj, isBasic: isBasic) }
}

func exprSuffix(subj: Expression, isBasic: Bool) -> SwiftParser<Expression> {
    var parser = (_exprPostfixSelf(subj) >>- exprSuffix(isBasic: isBasic))
        <|> (_exprInitializer(subj) >>- exprSuffix(isBasic: isBasic))
        <|> (_exprExplicitMember(subj) >>- exprSuffix(isBasic: isBasic))
        <|> (_exprFunctionCall(subj) >>- exprSuffix(isBasic: isBasic))
        <|> (_exprSubscript(subj) >>- exprSuffix(isBasic: isBasic))
        <|> (_exprOptionalChaining(subj) >>- exprSuffix(isBasic: isBasic))
        <|> (_exprPostfixUnary(subj) >>- exprSuffix(isBasic: isBasic))
    if !isBasic {
        parser = parser
            <|> (_exprTrailingClosure(subj) >>- exprSuffix(isBasic: isBasic))
    }
    return parser <|> pure(subj)
}

func _exprPostfixSelf(_ subj: Expression) -> SwiftParser<PostfixSelfExpression>  {
    return { _ in PostfixSelfExpression() }
        <^> OWS *> period *> kw_self
}

func _exprFunctionCall(_ subj: Expression) -> SwiftParser<FunctionCallExpression> {
    let arg = { label in { value in (label, value) }}
        <^> zeroOrOne(keywordOrIdentifier <* OWS <* colon) <* OWS <*> expr
    return { args in { trailingClosure in
        FunctionCallExpression(expression: subj, arguments: args, trailingClosure: trailingClosure) }}
        <^> (OHWS *> list(l_paren, arg, comma, r_paren))
        <*> zeroOrOne(OWS *> exprClosure)
}

func _exprTrailingClosure(_ subj: Expression) -> SwiftParser<FunctionCallExpression> {
    return { trailingClosure in
        FunctionCallExpression(expression: subj, arguments: [], trailingClosure: trailingClosure) }
        <^> (OWS *> exprClosure)
}

func _exprInitializer(_ subj: Expression) -> SwiftParser<InitializerExpression> {
    return { _ in InitializerExpression() }
        <^> OWS *> period *> kw_init
}


func _exprExplicitMember(_ subj: Expression) -> SwiftParser<ExplicitMemberExpression> {
    return { name in { generics in
        ExplicitMemberExpression(expression: subj, member: name) }}
        <^> (OWS *> period *> keywordOrIdentifier)
        <*> zeroOrOne(OWS *> genericArgs)
}


func _exprSubscript(_ subj: Expression) -> SwiftParser<SubscriptExpression> {
    return { args in
        SubscriptExpression(expression: subj, arguments: args) }
        <^> (OHWS *> list(l_square, expr, comma, r_square))
}

func _exprOptionalChaining(_ subj: Expression) -> SwiftParser<OptionalChainingExpression> {
    return { name in { generics in
        OptionalChainingExpression(expression: subj, member: name) }}
        <^> char("?") *> OWS *> period *> keywordOrIdentifier
        <*> zeroOrOne(OWS *> genericArgs)
}

func _exprDynamicType(_ subj: Expression) -> SwiftParser<DynamicTypeExpression> {
    return fail("not implemented")
}

func _exprPostfixUnary(_ subj: Expression) -> SwiftParser<PostfixUnaryOperation> {
    return
        { _ in PostfixUnaryOperation(operand: subj, operatorSymbol: "!") }
        <^> char("!")
}
