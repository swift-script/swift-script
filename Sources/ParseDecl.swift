import Runes
import TryParsec


fileprivate func asDecl(_ decl: Declaration) -> Declaration {
    return decl
}


let decl = _decl()
func _decl() -> SwiftParser<Declaration> {
    return (declFunction <&> asDecl)
        <|> (declConstant <&> asDecl)
        <|> (declVariable <&> asDecl)
}

func _declImport() -> SwiftParser<ImportDeclaration> {
    return fail("not implemented")
}

let declConstant = _declConstant()
func _declConstant() -> SwiftParser<ConstantDeclaration> {
    return { isStatic in {  name in { ty in { initializer in
        ConstantDeclaration(isStatic: isStatic != nil, name: name, type: ty, expression: initializer) }}}}
        <^> zeroOrOne(kw_static)
        <*> (OWS *> kw_let *> OWS *> identifier)
        <*> zeroOrOne(OWS *> type)
        <*> zeroOrOne(OWS *> equal *> OWS *> expr)
}


let declVariable = _declVariable()
func _declVariable() -> SwiftParser<VariableDeclaration> {
    return { isStatic in {  name in { ty in { initializer in
        VariableDeclaration(isStatic: isStatic != nil, name: name, type: ty, expression: initializer) }}}}
        <^> zeroOrOne(kw_static)
        <*> (OWS *> kw_let *> OWS *> identifier)
        <*> zeroOrOne(OWS *> type)
        <*> zeroOrOne(OWS *> equal *> OWS *> expr)
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

let declFunction = _declFunction()
func _declFunction() -> SwiftParser<FunctionDeclaration> {
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
