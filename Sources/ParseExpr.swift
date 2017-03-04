import Runes
import TryParsec


///
let exprIdentifier = _exprIdentifier()
func _exprIdentifier() -> SwiftParser<IdentifierExpression> {
    return fail("not implemented")
}

let exprSelf = _exprSelf()
func _exprSelf() -> SwiftParser<SelfExpression>  {
    return fail("not implemented")
}

let exprSuper = _exprSuper()
func _exprSuper() -> SwiftParser<SuperclassExpression>  {
    return fail("not implemented")
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

let exprPostfixSelf = _exprPostfixSelf()
func _exprPostfixSelf() -> SwiftParser<PostfixSelfExpression>  {
    return fail("not implemented")
}

let exprDynamicType = _exprDynamicType()
func _exprDynamicType() -> SwiftParser<DynamicTypeExpression> {
    return fail("not implemented")
}

let exprFunctionCall = _exprFunctionCall()
func _exprFunctionCall() -> SwiftParser<FunctionCallExpression> {
    return fail("not implemented")
}

let exprInitializer =  _exprInitializer()
func _exprInitializer() -> SwiftParser<InitializerExpression> {
    return fail("not iomplemented")
}


let exprExplicitMemeber = _exprExplicitMember()
func _exprExplicitMember() -> SwiftParser<ExplicitMemberExpression> {
    return fail("not implemented")
}


let exprSubscript = _exprSubscript()
func _exprSubscript() -> SwiftParser<SubscriptExpression> {
    return fail("not implemented")
}

let exprOptionalChanining = _exprOptionalChaining()
func _exprOptionalChaining() -> SwiftParser<OptionalChainingExpression> {
    return fail("not implemented")
}
