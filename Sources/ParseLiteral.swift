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
    return { elements in ArrayLiteral(value: elements) }
        <^> list(l_square, expr, comma, r_square)
}

let exprDictionaryLiteral = _exprDictionaryLiteral()
func _exprDictionaryLiteral() -> SwiftParser<DictionaryLiteral> {
    let item = { key in { val in (key, val) }}
        <^> (expr <* OWS <* colon) <*> (OWS *> expr)
    let items = sepBy1(item, OWS *> comma <* OWS)
        <|> (colon <&> { _ in [/* empty */] })
    return { items in DictionaryLiteral(value: items) }
        <^> l_square *> OWS *> items <* OWS <* r_square
}
