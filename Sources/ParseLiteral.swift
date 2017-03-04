import Runes
import TryParsec


// Literal expressions

let exprNilLiteral = _exprNilLiteral()
func _exprNilLiteral() -> SwiftParser<NilLiteral> {
    return fail("not implemented")
}

let exprBooleanLiteral = _exprBooleanLiteral()
func _exprBooleanLiteral() -> SwiftParser<BooleanLiteral> {
    return fail("not implemented")
}


let exprStringLiteral = _exprStringLiteral()
func _exprStringLiteral() -> SwiftParser<StringLiteral> {
    return fail("not implemented")
}

let exprIntegerLiteral = _exprIntegerLiteral()
func _exprIntegerLiteral() -> SwiftParser<IntegerLiteral> {
    return fail("not implemented")
}

let exprFloatLiteral = _exprFloatLiteral()
func _exprFloatLiteral() -> SwiftParser<FloatingPointLiteral> {
    return fail("not implemented")
}

let exprArrayLiteral = _exprArrayLiteral()
func _exprArrayLiteral() -> SwiftParser<ArrayLiteral> {
    return fail("not implemented")
}

let exprDictionaryLiteral = _exprDictionaryLiteral()
func _exprDictionaryLiteral() -> SwiftParser<DictionaryLiteral> {
    return fail("not implemented")
}
