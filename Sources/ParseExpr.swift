import Runes
import TryParsec


fileprivate func asExpr(expr: Expression) -> Expression {
    return expr
}

let expr = _expr()
func _expr() -> SwiftParser<Expression> {
    return exprSequence
}


let exprSequence = _exprSequence()
func _exprSequence() -> SwiftParser<Expression> {
    return
        exprSequenceElement >>- binarySuffix
}

let binOp = oper_infix <|> kw_as <|> kw_is

func binarySuffix(lhs: Expression) -> SwiftParser<Expression> {
    let bin: SwiftParser<Expression> = { op in { rhs in
        BinaryOperation(leftOperand: lhs, operatorSymbol: op, rightOperand: rhs) }}
        <^> binOp <*> expr
    return (bin >>- binarySuffix)
        <|> pure(lhs)
}

let exprSequenceElement = _exprSequencceElement()
func _exprSequencceElement() -> SwiftParser<Expression> {
    let parseTry
        = ({ _ in "try!" } <^> kw_try *> char("?") *> WS)
            <|> ({ _ in "try?" } <^> kw_try *> char("?") *> WS)
            <|> ({ _ in "try" } <^> kw_try *> WS)
            <|> pure(nil)
    return { op in { subExpr in
        op != nil ? PrefixUnaryOperation(operatorSymbol: op!, operand: subExpr) : subExpr }}
        <^> parseTry
        <*> exprUnary
}


let exprUnary = _exprUnary()
func _exprUnary() -> SwiftParser<Expression> {
    return { op in { subExpr in
        op != nil ? PrefixUnaryOperation(operatorSymbol: op!, operand: subExpr) : subExpr }}
        <^> zeroOrOne(oper_prefix)
        <*> exprAtom
}

let exprAtom = _exprAtom()
func _exprAtom() -> SwiftParser<Expression> {
    return exprPrimitive >>- exprSuffix
}

//-----------------------------------------------------------------------
// primitive expressions

let exprPrimitive = _exprPrimitive()
func _exprPrimitive() -> SwiftParser<Expression> {
    return (exprStringLiteral <&> asExpr)
        <|> (exprFloatLiteral <&> asExpr)
        <|> (exprIntegerLiteral <&> asExpr)
        <|> (exprArrayLiteral <&> asExpr)
        <|> (exprDictionaryLiteral <&> asExpr)
        <|> (exprIdentifier <&> asExpr)
        <|> (exprParenthesized <&> asExpr)
        <|> (exprTuple <&> asExpr)
        <|> (exprClosure <&> asExpr)
}


let exprIdentifier = _exprIdentifier()
func _exprIdentifier() -> SwiftParser<IdentifierExpression> {
    return IdentifierExpression.init <^> identifier
}

let exprSelf = _exprSelf()
func _exprSelf() -> SwiftParser<SelfExpression>  {
    return { _ in SelfExpression() } <^> kw_self
}

let exprSuper = _exprSuper()
func _exprSuper() -> SwiftParser<SuperclassExpression>  {
    return { _ in SuperclassExpression() } <^> kw_Self
}

let exprClosure = _exprClosure()
func _exprClosure() -> SwiftParser<ClosureExpression>  {
    let params: SwiftParser<[String]> = sepBy1(identifier, OWS *> comma <* OWS)
    let sig = { args in { th in { ty in (args, th != nil, ty) }}}
        <^> zeroOrOne(params)
        <*> zeroOrOne(OWS *> kw_throws)
        <*> zeroOrOne(OWS *> arrow *> type)
    
    return { sig in { body in
        let args: [(String, Type_?)] = (sig?.0?.map({ ($0, nil) })) ?? []
        let hasThrows = sig == nil ? false : sig!.1
        let retType  = sig == nil ? nil : sig!.2
        return ClosureExpression(arguments: args, hasThrows: hasThrows, result: retType, statements: body) }}
        <^> l_brace
        *> (zeroOrOne(sig) <* kw_in)
        <*> (OWS *> stmtBraceItems <* r_brace)
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

func exprSuffix(subj: Expression) -> SwiftParser<Expression> {
    return (_exprPostfixSelf(subj) >>- exprSuffix)
        <|> (_exprInitializer(subj) >>- exprSuffix)
        <|> (_exprExplicitMember(subj) >>- exprSuffix)
        <|> (_exprFunctionCall(subj) >>- exprSuffix)
        <|> (_exprSubscript(subj) >>- exprSuffix)
        <|> (_exprOptionalChaining(subj) >>- exprSuffix)
        <|> (_exprPostfixUnary(subj) >>- exprSuffix)
        <|> pure(subj)
        //        <|> (_exprTrailingClosure(subj) >>- exprSuffix)
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

func _exprInitializer(_ subj: Expression) -> SwiftParser<InitializerExpression> {
    return { _ in InitializerExpression() }
        <^> OWS *> period *> kw_init
}


func _exprExplicitMember(_ subj: Expression) -> SwiftParser<ExplicitMemberExpression> {
    return { name in ExplicitMemberExpression(expression: subj, member: name) }
        <^> OWS *> period *> keywordOrIdentifier
}


func _exprSubscript(_ subj: Expression) -> SwiftParser<SubscriptExpression> {
    return { args in
        SubscriptExpression(expression: subj, arguments: args) }
        <^> (OHWS *> list(l_square, expr, comma, r_square))
}

func _exprOptionalChaining(_ subj: Expression) -> SwiftParser<OptionalChainingExpression> {
    return { name in OptionalChainingExpression(expression: subj, member: name) }
        <^> char("?") *> OWS *> period *> keywordOrIdentifier
}

func _exprDynamicType(_ subj: Expression) -> SwiftParser<DynamicTypeExpression> {
    return fail("not implemented")
}

func _exprPostfixUnary(_ subj: Expression) -> SwiftParser<PostfixUnaryOperation> {
    return
        { _ in PostfixUnaryOperation(operand: subj, operatorSymbol: "!") }
        <^> char("!")
}
