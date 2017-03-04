import Runes
import TryParsec


// Literal expressions

let exprNilLiteral = _exprNilLiteral()
func _exprNilLiteral() -> SwiftParser<NilLiteral> {
    return { _ in NilLiteral() } <^> kw_nil
}

let exprBooleanLiteral = _exprBooleanLiteral()
func _exprBooleanLiteral() -> SwiftParser<BooleanLiteral> {
    return ({ _ in BooleanLiteral(value: false) } <^> kw_false)
        <|> ({ _ in BooleanLiteral(value: true) } <^> kw_true)
}


let exprStringLiteral = _exprStringLiteral()
func _exprStringLiteral() -> SwiftParser<StringLiteral> {
    return { value in StringLiteral(value: value) } <^> stringLiteral
}

let exprIntegerLiteral = _exprIntegerLiteral()
func _exprIntegerLiteral() -> SwiftParser<IntegerLiteral> {
    return { value in IntegerLiteral(value: value) } <^> integerLiteral
}

let exprFloatLiteral = _exprFloatLiteral()
func _exprFloatLiteral() -> SwiftParser<FloatingPointLiteral> {
    return { value in FloatingPointLiteral(value: value) } <^> floatLiteral
}

let exprArrayLiteral = _exprArrayLiteral()
func _exprArrayLiteral() -> SwiftParser<ArrayLiteral> {
    return fail("not implemented")
}

let exprDictionaryLiteral = _exprDictionaryLiteral()
func _exprDictionaryLiteral() -> SwiftParser<DictionaryLiteral> {
    return fail("not implemented")
}
