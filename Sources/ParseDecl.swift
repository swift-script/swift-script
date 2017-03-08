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
        <|> (declClass <&> asDecl)
        <|> (declInitializer <&> asDecl)
}

func _declImport() -> SwiftParser<ImportDeclaration> {
    return fail("not implemented")
}

let declConstant = _declConstant()
func _declConstant() -> SwiftParser<ConstantDeclaration> {
    return { isStatic in {  name in { ty in { initializer in
        ConstantDeclaration(isStatic: isStatic != nil, name: name, type: ty, expression: initializer) }}}}
        <^> zeroOrOne(kw_static <* OWS)
        <*> (kw_let *> OWS *> identifier)
        <*> zeroOrOne(OWS *> colon *> OWS *> type)
        <*> zeroOrOne(OWS *> equal *> OWS *> expr)
}


let declVariable = _declVariable()
func _declVariable() -> SwiftParser<VariableDeclaration> {
    return { isStatic in {  name in { ty in { initializer in
        VariableDeclaration(isStatic: isStatic != nil, name: name, type: ty, expression: initializer) }}}}
        <^> zeroOrOne(kw_static <* OWS)
        <*> (kw_var *> OWS *> identifier)
        <*> zeroOrOne(OWS *> colon *> OWS *> type)
        <*> zeroOrOne(OWS *> equal *> OWS *> expr)
}

func _declTypeAlias() -> SwiftParser<TypeAliasDeclaration> {
    return fail("not implemented")
}

let declParam = _declParam()
func _declParam() -> SwiftParser<Parameter> {
    let label = (identifier <|> kw__)
    return { apiName in { paramName in { ty in { isVariadic in { defaultValue in
        Parameter(externalParameterName: apiName, localParameterName: paramName, type: ty, defaultArgument: defaultValue) }}}}}
        <^> zeroOrOne(label <* WS)
        <*> (label <* OWS <* colon)
        <*> (OWS *> type)
        <*> zeroOrOne(ellipsis)
        <*> zeroOrOne(OWS *> equal *> OWS *> expr)
}

let declFunction = _declFunction()
func _declFunction() -> SwiftParser<FunctionDeclaration> {
    let params = list(l_paren, declParam, comma, r_paren)
    return  { isStatic in { name in { params in { hasThrows in { retType in { body in
        FunctionDeclaration(isStatic: isStatic != nil, name: name, arguments: params, result: retType, hasThrows: hasThrows != nil, body: body) }}}}}}
        <^> zeroOrOne(kw_static <* OWS)
        <*> (kw_func *> WS *> identifier)
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

let declClass = _declClass()
func _declClass() -> SwiftParser<ClassDeclaration­> {
    return { name in { inherits in { members in
        ClassDeclaration­(name: name, superTypes: inherits ?? [], members: members) }}}
        <^> (kw_class *> WS *> identifier)
        <*> zeroOrOne(OWS *> colon *> sepBy1(type, OWS *> comma <* OWS))
        <*> (OWS *> l_brace *> OWS *> sepEndBy(decl, stmtSep) <* OWS <* r_brace)
}

func _declProtocol() -> SwiftParser<ProtocolDeclaration­> {
    return fail("not implemented")
}

let declInitializer = _declInitializer()
func _declInitializer() -> SwiftParser<InitializerDeclaration­> {
    let params = list(l_paren, declParam, comma, r_paren)
    return  { isFailable in { params in { hasThrows in { body in
        InitializerDeclaration­(arguments: params, isFailable: isFailable != nil, hasThrows: hasThrows != nil, body: body) }}}}
        <^> (kw_init *> zeroOrOne(char("?")))
        <*> (OWS *> params)
        <*> zeroOrOne(OWS *> kw_throws)
        <*> (OWS *> stmtBrace)
}

func _declDeinitializer() -> SwiftParser<DeinitializerDeclaration­> {
    return fail("not implemented")
}

func _declExtension() -> SwiftParser<ExtensionDeclaration­> {
    return fail("not implemented")
}
