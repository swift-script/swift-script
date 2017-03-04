import Runes
import TryParsec



func _declImport() -> SwiftParser<ImportDeclaration> {
    return fail("not implemented")
}

func _declConstant() -> SwiftParser<ConstantDeclaration> {
    return fail("not implemented")
}

func _declVariable() -> SwiftParser<ConstantDeclaration> {
    return fail("not implemented")
}

func _declTypeAlias() -> SwiftParser<TypeAliasDeclaration> {
    return fail("not implemented")
}

let declParam = _declParam()
func _declParam() -> SwiftParser<(String?, String, Type_, Expression?)> {
    let label = (identifier <|> kw__)
    return { apiName in { paramName in { type in { isVariadic in
        (apiName, paramName, type, nil) }}}}
        <^> zeroOrOne(label <* WS)
        <*> (label <* OWS <* colon)
        <*> (OWS *> type)
        <*> zeroOrOne(ellipsis)
}


func _declFunction() -> SwiftParser<Any> {
    let params = list(l_paren, declParam, comma, r_paren)
    return  { name in { params in { hasThrows in { retType in { body in
        FunctionDeclaration(name: name, arguments: params, result: retType, hasThrows: hasThrows != nil, body: body) }}}}}
        <^> (kw_func *> WS *> identifier)
        <*> (OWS *> params)
        <*> zeroOrOne(OWS *> kw_throws)
        <*> zeroOrOne(OWS *> arrow *> OWS *> type)
        <*> (OWS *> stmtBrace)
}

func _declEnum() -> SwiftParser<EnumDeclaration­> {
    return fail("not implemented")
}

func _declStruct() -> SwiftParser<StructDeclaration­> {
    return fail("not implemented")
}

func _declClass() -> SwiftParser<ClassDeclaration­> {
    return fail("not implemented")
}

func _declProtocol() -> SwiftParser<ProtocolDeclaration­> {
    return fail("not implemented")
}

func _declInitializer() -> SwiftParser<InitializerDeclaration­> {
    return fail("not implemented")
}

func _declDeinitializer() -> SwiftParser<DeinitializerDeclaration­> {
    return fail("not implemented")
}

func _declExtension() -> SwiftParser<ExtensionDeclaration­> {
    return fail("not implemented")
}
