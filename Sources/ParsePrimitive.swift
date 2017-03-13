import Runes
import TryParsec

/// Haskell `(:)` (cons operator) for replacing slow `[x] + xs`.
/// Note: copy from TryParsec code
internal func cons<C: RangeReplaceableCollection>(_ x: C.Iterator.Element) -> (C) -> C
{
    return { xs in
        var xs = xs
        xs.insert(x, at: xs.startIndex)
        return xs
    }
}

func chars(_ str: SwiftSource) -> SwiftParser<String.UnicodeScalarView> {
    return Parser { input in
        let idx = input.index(input.startIndex, offsetBy: str.count)
        if input.prefix(upTo: idx) == str {
            return .done(input.suffix(from: idx), str)
        } else {
            return .fail(input, [], "chars")
        }
    }
}

func string(_ str: SwiftSource) -> SwiftParser<String> {
    return chars(str) <&> { _ in String(str) }
}

// ------------------------------------------------------------------------
// Panctuators

let l_paren = char("(")
let r_paren = char(")")
let l_brace = char("{")
let r_brace = char("}")
let l_square = char("[")
let r_square = char("]")
let l_angle = char("<")
let r_angle = char(">")
let colon = char(":")
let semi = char(";")
let period = char(".")
let comma = char(",")
let arrow = chars("->")
let ellipsis = chars("...")
let equal = char("=")

// ------------------------------------------------------------------------
// Litrals


let stringLiteral = _stringLiteral()
private func _stringLiteral() -> SwiftParser<String> {
    let normChar = satisfy { $0 != "\\" && $0 != "\"" }
    let _escapedCharMappings: [UnicodeScalar : UnicodeScalar] = [
        "\"": "\"",
        "\\": "\\",
        "/": "/",
        "n": "\n",
        "r": "\r",
        "t": "\t",
    ]
    let _escapedCharMappingKeys = Set(_escapedCharMappings.keys)
    let _escapedCharKey = satisfy { _escapedCharMappingKeys.contains($0) }
    let escapedChar = char("\\") *> _escapedCharKey <&> { x in _escapedCharMappings[x]! }
    let validChar = normChar <|> escapedChar
    
    return (char("\"") *> many(validChar) <* char("\"")) <&> String.init
}


let integerLiteral = _integerLiteral()
private func _integerLiteral() -> SwiftParser<Int> {
    return many1(digit) <&> { Int(String($0))! }
}

let floatLiteral = _floatLiteral()
private func _floatLiteral() -> SwiftParser<Float> {
    return
        { real in { frac in Float(String(real) + "." + String(frac))! }}
            <^> many1(digit) <* period <*> many1(digit)
}

// ----------------------------------------------------------------------------------
// Identifiers

private func isValidIdentifierContinuationCodePoint(_ scalar: UnicodeScalar) -> Bool {
    let c = scalar.value
    return (c == 0x5F)// '_'
        || (c >= 0x30 && c <= 0x39) // '0' ... '9'
        || (c >= 0x41 && c <= 0x5A) // 'A' ... 'Z'
        || (c >= 0x61 && c <= 0x7a) // 'a' ... 'z'
        
        ||  c == 0x00A8 || c == 0x00AA || c == 0x00AD || c == 0x00AF
        || (c >= 0x00B2 && c <= 0x00B5) || (c >= 0x00B7 && c <= 0x00BA)
        || (c >= 0x00BC && c <= 0x00BE) || (c >= 0x00C0 && c <= 0x00D6)
        || (c >= 0x00D8 && c <= 0x00F6) || (c >= 0x00F8 && c <= 0x00FF)
        
        || (c >= 0x0100 && c <= 0x167F)
        || (c >= 0x1681 && c <= 0x180D)
        || (c >= 0x180F && c <= 0x1FFF)
        
        || (c >= 0x200B && c <= 0x200D)
        || (c >= 0x202A && c <= 0x202E)
        || (c >= 0x203F && c <= 0x2040)
        || c == 0x2054
        || (c >= 0x2060 && c <= 0x206F)
        
        || (c >= 0x2070 && c <= 0x218F)
        || (c >= 0x2460 && c <= 0x24FF)
        || (c >= 0x2776 && c <= 0x2793)
        || (c >= 0x2C00 && c <= 0x2DFF)
        || (c >= 0x2E80 && c <= 0x2FFF)
        
        || (c >= 0x3004 && c <= 0x3007)
        || (c >= 0x3021 && c <= 0x302F)
        || (c >= 0x3031 && c <= 0x303F)
        
        || (c >= 0x3040 && c <= 0xD7FF)
        
        || (c >= 0xF900 && c <= 0xFD3D)
        || (c >= 0xFD40 && c <= 0xFDCF)
        || (c >= 0xFDF0 && c <= 0xFE44)
        || (c >= 0xFE47 && c <= 0xFFF8)
        
        || (c >= 0x10000 && c <= 0x1FFFD)
        || (c >= 0x20000 && c <= 0x2FFFD)
        || (c >= 0x30000 && c <= 0x3FFFD)
        || (c >= 0x40000 && c <= 0x4FFFD)
        || (c >= 0x50000 && c <= 0x5FFFD)
        || (c >= 0x60000 && c <= 0x6FFFD)
        || (c >= 0x70000 && c <= 0x7FFFD)
        || (c >= 0x80000 && c <= 0x8FFFD)
        || (c >= 0x90000 && c <= 0x9FFFD)
        || (c >= 0xA0000 && c <= 0xAFFFD)
        || (c >= 0xB0000 && c <= 0xBFFFD)
        || (c >= 0xC0000 && c <= 0xCFFFD)
        || (c >= 0xD0000 && c <= 0xDFFFD)
        || (c >= 0xE0000 && c <= 0xEFFFD)
}

private func isValidIdentifierStartCodePoint(_ scalar: UnicodeScalar) -> Bool {
    if !isValidIdentifierContinuationCodePoint(scalar) {
        return false
    }
    let c = scalar.value
    if (c >= 0x30 && c <= 0x39) || // '0' ... '9'
        (c >= 0x0300 && c <= 0x036F) ||
        (c >= 0x1DC0 && c <= 0x1DFF) ||
        (c >= 0x20D0 && c <= 0x20FF) ||
        (c >= 0xFE20 && c <= 0xFE2F) {
        return false
    }
    return true
}

private let startOfIdentifier = _startOfIdentifier()
private func _startOfIdentifier() -> SwiftParser<UnicodeScalar> {
    return satisfy(isValidIdentifierStartCodePoint)
}

private let continuationOfIdentifier = _continuationOfIdentifier()
private func _continuationOfIdentifier() -> SwiftParser<UnicodeScalar> {
    return satisfy(isValidIdentifierContinuationCodePoint)
}

private let identifierBody = _identifierBody()
private func _identifierBody() -> SwiftParser<String> {
    return (cons <^> startOfIdentifier <*> many(continuationOfIdentifier)) <&> String.init
}

let escapedIdentifier = _escapedIdentifier()
private func _escapedIdentifier() -> SwiftParser<String> {
    return char("`") *> identifierBody <* char("`")
}

let identifier = _identifier()
private func _identifier() -> SwiftParser<String> {
    return escapedIdentifier <|> Parser { input in
        let reply = parse(identifierBody, input)
        switch reply {
        case let .done(input2, ident) where isKeyword(ident):
            return .fail(input2, [], "identifier is keyword")
        default:
            return reply
        }
    }
}

let keywordOrIdentifier = _keywordOrIdentifier()
private func _keywordOrIdentifier() -> SwiftParser<String> {
    return identifierBody <|> escapedIdentifier
}

let dollarIdentifier = _dollarIdentifier()
private func _dollarIdentifier() -> SwiftParser<String> {
    return String.init
        <^> (cons <^> char("$") <*> many1(satisfy(isDigit))) <* not(satisfy(isValidIdentifierContinuationCodePoint))
}

// ----------------------------------------------------------------------------------
// Keywords


let knownKeywords: Set<String> = [
    "associatedtype",
    "class",
    "deinit",
    "enum",
    "extension",
    "func",
    "import",
    "init",
    "inout",
    "let",
    "operator",
    "precedencegroup",
    "protocol",
    "struct",
    "subscript",
    "typealias",
    "var",
    "fileprivate",
    "internal",
    "private",
    "public",
    "static",
    "defer",
    "if",
    "guard",
    "do",
    "preset",
    "else",
    "for",
    "in",
    "while",
    "return",
    "break",
    "continue",
    "fallthrough",
    "switch",
    "case",
    "default",
    "where",
    "catch",
    "as",
    "Any",
    "false",
    "is",
    "nil",
    "rethrows",
    "super",
    "self",
    "Self",
    "throw",
    "true",
    "try",
    "throws",
    "_",
]

private func isKeyword(_ str: String) -> Bool {
    return knownKeywords.contains(str)
}

private func kw(_ x: String.UnicodeScalarView) -> SwiftParser<String> {
    return string(x) <* not(satisfy(isValidIdentifierContinuationCodePoint))
}

let kw_associatedtype = kw("associatedtype")
let kw_class = kw("class")
let kw_deinit = kw("deinit")
let kw_enum = kw("enum")
let kw_extension = kw("extension")
let kw_func = kw("func")
let kw_import = kw("import")
let kw_init = kw("init")
let kw_inout = kw("inout")
let kw_let = kw("let")
let kw_operator = kw("operator")
let kw_precedencegroup = kw("precedencegroup")
let kw_protocol = kw("protocol")
let kw_struct = kw("struct")
let kw_subscript = kw("subscript")
let kw_typealias = kw("typealias")
let kw_var = kw("var")

let kw_fileprivate = kw("fileprivate")
let kw_internal = kw("internal")
let kw_private = kw("private")
let kw_public = kw("public")
let kw_static = kw("static")

let kw_defer = kw("defer")
let kw_if = kw("if")
let kw_guard = kw("guard")
let kw_do = kw("do")
let kw_repeat = kw("repeat")
let kw_else = kw("else")
let kw_for = kw("for")
let kw_in = kw("in")
let kw_while = kw("while")
let kw_return = kw("return")
let kw_break = kw("break")
let kw_continue = kw("continue")
let kw_fallthrough = kw("fallthrough")
let kw_switch = kw("switch")
let kw_case = kw("case")
let kw_default = kw("default")
let kw_where = kw("where")
let kw_catch = kw("catch")

let kw_as = kw("as")
let kw_Any = kw("Any")
let kw_false = kw("false")
let kw_is = kw("is")
let kw_nil = kw("nil")
let kw_rethrows = kw("rethrows")
let kw_super = kw("super")
let kw_self = kw("self")
let kw_Self = kw("Self")
let kw_throw = kw("throw")
let kw_true = kw("true")
let kw_try = kw("try")
let kw_throws = kw("throws")

let kw__ = kw("_")


// ------------------------------------------------------------------------
// Operator

let knownOperatorChars = Set("/=-+*%<>!&|^~.?".unicodeScalars)
func isValidOperatorStartCodePoint(_ scalar: UnicodeScalar) -> Bool {
    // ASCII operator chars.
    if knownOperatorChars.contains(scalar) {
        return true
    }
    // Unicode math, symbol, arrow, dingbat, and line/box drawing chars.
    let C = scalar.value
    return (C >= 0x00A1 && C <= 0x00A7)
        || C == 0x00A9 || C == 0x00AB || C == 0x00AC || C == 0x00AE
        || C == 0x00B0 || C == 0x00B1 || C == 0x00B6 || C == 0x00BB
        || C == 0x00BF || C == 0x00D7 || C == 0x00F7
        || C == 0x2016 || C == 0x2017 || (C >= 0x2020 && C <= 0x2027)
        || (C >= 0x2030 && C <= 0x203E) || (C >= 0x2041 && C <= 0x2053)
        || (C >= 0x2055 && C <= 0x205E) || (C >= 0x2190 && C <= 0x23FF)
        || (C >= 0x2500 && C <= 0x2775) || (C >= 0x2794 && C <= 0x2BFF)
        || (C >= 0x2E00 && C <= 0x2E7F) || (C >= 0x3001 && C <= 0x3003)
        || (C >= 0x3008 && C <= 0x3030);
}

func isValidOperatorContinuationCodePoint(_ scalar: UnicodeScalar) -> Bool {
    if isValidOperatorStartCodePoint(scalar) {
        return true
    }
    // Unicode combining characters and variation selectors.
    let C = scalar.value
    return (C >= 0x0300 && C <= 0x036F)
        || (C >= 0x1DC0 && C <= 0x1DFF)
        || (C >= 0x20D0 && C <= 0x20FF)
        || (C >= 0xFE00 && C <= 0xFE0F)
        || (C >= 0xFE20 && C <= 0xFE2F)
        || (C >= 0xE0100 && C <= 0xE01EF);
    
}

func rightBound() -> SwiftParser<Void> {
    return (noneOf(" \r\n\t)]},;:") *> pure(())) <|> endOfInput()
}

let startOfOperator = _startOfOperator()
private func _startOfOperator() -> SwiftParser<UnicodeScalar> {
    return satisfy(isValidOperatorStartCodePoint)
}

let continuationOfOperator = _continuationOfOperator()
private func _continuationOfOperator() -> SwiftParser<UnicodeScalar> {
    return satisfy(isValidOperatorContinuationCodePoint)
}

let operatorBody = _operatorBody()
private func _operatorBody() -> SwiftParser<String> {
    return (cons <^> startOfOperator <*> many(continuationOfOperator)) <&> String.init
}

let oper_prefix = operatorBody <* lookAhead(rightBound())
let oper_postfix = operatorBody <* lookAhead(rightBound())
let oper_infix = (operatorBody <* lookAhead(rightBound())) <|> (WS *> operatorBody <* WS)

func oper_infix(_ str: String.UnicodeScalarView) -> SwiftParser<String> {
    return string(str) <* lookAhead(rightBound()) <|> (WS *> string(str) <* WS)
}

func oper_postfix(_ str: String.UnicodeScalarView) -> SwiftParser<String> {
    return string(str) <* lookAhead(rightBound())
}

// ------------------------------------------------------------------------
// White spaces

private let horizontalWhitespaces: Set<UnicodeScalar> = [ " ", "\t" ]
private let verticalWhitespaces: Set<UnicodeScalar> = [ "\n", "\r" ]

private func isHorizontalSpace(_ c: UnicodeScalar) -> Bool {
    return horizontalWhitespaces.contains(c)
}
private func isVerticalSpace(_ c: UnicodeScalar) -> Bool {
    return verticalWhitespaces.contains(c)
}
private func isSpace(_ c: UnicodeScalar) -> Bool {
    return isHorizontalSpace(c) || isVerticalSpace(c)
}

private func _optionalHorizontalWhitespaces() -> SwiftParser<()> {
    return skipMany(satisfy(isHorizontalSpace))
}

private func _optionalWhitespaces() -> SwiftParser<()> {
    return skipMany(satisfy(isSpace))
}

private func _verticalSpace() -> SwiftParser<()> {
    return skipMany1(OHWS *> satisfy(isVerticalSpace))
}

private func _whitespace() -> SwiftParser<()> {
    return skipMany1(satisfy(isSpace))
}

let OHWS = _optionalHorizontalWhitespaces()
let OWS = _optionalWhitespaces()
let WS = _whitespace()
let VS = _verticalSpace()

// ------------------------------------------------------------------------
// Misc

func not<In, Out>(_ p: Parser<In, Out>) -> Parser<In, Void> {
    return Parser { input in
        let reply = parse(p, input)
        switch reply {
        case .fail:
            return .done(input, ())
        case .done:
            return .fail(input, [], "notFollowedBy")
        }
    }
}

func list<P, T, S>(_ tokL: SwiftParser<P>, _ elem: @autoclosure @escaping () -> SwiftParser<T>, _ tokS: SwiftParser<S>, _ tokR: SwiftParser<P>) -> SwiftParser<[T]> {
    return tokL *> OWS *> sepBy(elem(), OWS *> tokS <* OWS) <* OWS <* tokR
}

func list1<P, T, S>(tokL: SwiftParser<P>, elem: SwiftParser<T>,  tokS: SwiftParser<S>, tokR: SwiftParser<P>) -> SwiftParser<[T]> {
    return tokL *> OWS *> sepBy1(elem, OWS *> tokS <* OWS) <* OWS <* tokR
}

