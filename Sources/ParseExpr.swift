import Runes
import TryParsec


fileprivate func asExpr(expr: Expression) -> Expression {
    return expr
}

let expr = _expr()
func _expr() -> SwiftParser<Expression> {
    return _exprSequencceElement()
}

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
        <|> (exprTuple <&> asExpr)
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
    return fail("not implemented")
}

let exprParenthesized = _exprParenthesized()
func _exprParenthesized() -> SwiftParser<ParenthesizedExpression>  {
    return fail("not implemented")
}

let exprTuple = _exprTuple()
func _exprTuple() -> SwiftParser<TupleExpression>  {
    return fail("not implemented")
}

let exprImplicitMember = _exprImplicitMember()
func _exprImplicitMember() -> SwiftParser<ImplicitMemberExpression>  {
    return fail("not implemented")
}


let exprWildcard = _exprWildcard()
func _exprWildcard() -> SwiftParser<WildcardExpression> {
    return fail("not implemented")
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
        <|> (_exprInitializer(subj) >>- exprSuffix)
        <|> (_exprInitializer(subj) >>- exprSuffix)
//        <|> (_exprTrailingClosure(subj) >>- exprSuffix)
}

func _exprPostfixSelf(_ subj: Expression) -> SwiftParser<PostfixSelfExpression>  {
    return fail("not implemented")
}

func _exprFunctionCall(_ subj: Expression) -> SwiftParser<FunctionCallExpression> {
    return fail("not implemented")
}

func _exprInitializer(_ subj: Expression) -> SwiftParser<InitializerExpression> {
    return fail("not iomplemented")
}


func _exprExplicitMember(_ subj: Expression) -> SwiftParser<ExplicitMemberExpression> {
    return fail("not implemented")
}


func _exprSubscript(_ subj: Expression) -> SwiftParser<SubscriptExpression> {
    return fail("not implemented")
}

func _exprOptionalChaining(_ subj: Expression) -> SwiftParser<OptionalChainingExpression> {
    return fail("not implemented")
}

func _exprDynamicType(_ subj: Expression) -> SwiftParser<DynamicTypeExpression> {
    return fail("not implemented")
}

