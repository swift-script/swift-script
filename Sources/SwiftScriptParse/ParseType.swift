import SwiftScriptAST
import Runes
import TryParsec

fileprivate func asType(ty: Type_) -> Type_ {
    return ty
}

let type = _type()
func _type() -> SwiftParser<Type_> {
    return typeFunction <|> typeComposition
}

let typeFunction = _typeFunction()
func _typeFunction() -> SwiftParser<Type_> {
    return { args in { retType in
        FunctionType(arguments: args, returnType: retType)}}
        <^> list(l_paren, type, comma, r_paren)
        <*> (OWS *> arrow *> OWS *> type)
}

let typeComposition = _typeComposition()
func _typeComposition() -> SwiftParser<Type_> {
    return { types in
        return types.count == 1 ? types[0] : ProtocolCompositionType(types: types) }
        <^> sepBy1(typeSimple, oper_infix("&"))
}

let typeSimple = _typeSimple()
func _typeSimple() -> SwiftParser<Type_> {
    return typePrimitive >>- typeSuffix
}

let typePrimitive = _typePrimitive()
func _typePrimitive() -> SwiftParser<Type_>{
    return (typeIdent <&> asType)
        <|> (typeArray <&> asType)
        <|> (typeDictionary <&> asType)
        <|> (typeTuple <&> asType)
}

func typeSuffix(base: Type_) -> SwiftParser<Type_> {
    let optional: SwiftParser<Type_> = char("?") <&> { _ in OptionalType(type: base) }
    let implicitlyUnwrappedOptional: SwiftParser<Type_> = char("!") <&> { _ in OptionalType(type: base) }
    return (optional >>- typeSuffix)
        <|> (implicitlyUnwrappedOptional >>- typeSuffix)
        <|> pure(base)
}

let typeIdent = _typeIdent()
func _typeIdent() -> SwiftParser<TypeIdentifier> {
    return { name in
        TypeIdentifier(names: [name]) }
        <^> identifier
}

let typeArray = _typeArray()
func _typeArray() -> SwiftParser<ArrayType> {
    return { ty in
        ArrayType(type: ty) }
        <^> l_square *> OWS *> type <* OWS <* r_square
}

let typeDictionary = _typeDictionary()
func _typeDictionary() -> SwiftParser<DictionaryType> {
    return { key in { value in
        DictionaryType(keyType: key, valueType: value) }}
        <^> (l_square)
        *> (OWS *> type)
        <*> (OWS *> colon *> OWS *> type)
        <* (OWS *> r_square)
}

let typeTuple = _typeTuple()
func _typeTuple() -> SwiftParser<TupleType> {
    let element: SwiftParser<(String?, Type_)> = { label in { ty in (label, ty)}}
        <^> zeroOrOne(keywordOrIdentifier <* OWS <* colon <* OWS)
        <*> type
    return { elements in
        TupleType.init(elements: elements) }
        <^> list(l_paren, element, comma, r_paren)
}
