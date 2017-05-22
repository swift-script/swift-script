import SwiftAST
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
func _exprDictionaryLiteral() -> SwiftParser<SwiftAST.DictionaryLiteral> {
    let item = { key in { val in (key, val) }}
        <^> (expr <* OWS <* colon) <*> (OWS *> expr)
    let items = sepBy1(item, OWS *> comma <* OWS)
        <|> (colon <&> { _ in [/* empty */] })
    return { items in DictionaryLiteral(value: items) }
        <^> l_square *> OWS *> items <* OWS <* r_square
}

/// - SeeAlso: https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html#//apple_ref/swift/grammar/interpolated-string-literal
let exprStringInterpolationLiteral = _exprStringInterpolationLiteral()
private func _exprStringInterpolationLiteral() -> SwiftParser<StringInterpolationLiteral> {
    return char("\"") *> _exprStringInterpolationLiteralNoQuotes() <* char("\"")
}

/// - Todo: Improve this.
private func _exprStringInterpolationLiteralNoQuotes() -> SwiftParser<StringInterpolationLiteral> {
    let backslashed: SwiftParser<Expression> = TryParsec.string("\\(") *> expr <* char(")")

    let stringLiteralForInterpolation: SwiftParser<Expression> =
        manyTill(not("\""), lookAhead( TryParsec.string("\\(") *> pure()))
            <&> { StringLiteral(value: String($0)) }

    let head = { x in { rest in StringInterpolationLiteral(segments: cons(x)(rest.segments)) }}
        <^> (backslashed <|> stringLiteralForInterpolation)
        <*> _exprStringInterpolationLiteralNoQuotes()

    return head <|> pure(StringInterpolationLiteral(segments: []))
}

