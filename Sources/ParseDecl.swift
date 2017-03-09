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


fileprivate struct GenericParam {
    var param: String
    var requirement: Type_?
}

fileprivate struct GenericRequirement {
    enum Kind {
        case inherit
        case equals
    }
    var param: String
    var kind: Kind
    var requirement: Type_
}

fileprivate let declGenericParams = _declGenericParams()
fileprivate func _declGenericParams() -> SwiftParser<[GenericParam]> {
    let param: SwiftParser<GenericParam> = { ident in { ty in GenericParam(param: ident, requirement: ty) }}
        <^> identifier <*> zeroOrOne(OWS *> colon *> type)
    return list(l_angle, param, comma, r_angle)
}


fileprivate let declGenericWhere = _declGenericWhere()
fileprivate func _declGenericWhere() -> SwiftParser<[GenericRequirement]> {
    let inheritR: SwiftParser<(GenericRequirement.Kind, Type_)> = (OWS *> colon *> OWS  *> type) <&> { ty in (.inherit, ty) }
    let equalR: SwiftParser<(GenericRequirement.Kind, Type_)> = (oper_infix("==") *> type) <&> { ty in (.equals, ty) }
    let requirement: SwiftParser<GenericRequirement> = { ident in { req in GenericRequirement(param: ident, kind: req.0, requirement: req.1) }}
        <^> identifier <*> (inheritR <|> equalR)
    return (kw_where *> OWS *> sepBy1(requirement, OWS *> comma <* OWS))
}

let declFunction = _declFunction()
func _declFunction() -> SwiftParser<FunctionDeclaration> {
    
    struct FuncSignature {
        let params: [Parameter]
        let hasThrows: Bool
        let retType: Type_?
    }
    let signature: SwiftParser<FuncSignature> = { params in { hasThrows in { retType in
        FuncSignature(params: params, hasThrows: hasThrows != nil, retType: retType) }}}
        <^> list(l_paren, declParam, comma, r_paren)
        <*> zeroOrOne(OWS *> kw_throws)
        <*> zeroOrOne(OWS *> arrow *> OWS *> type)
    
    return  { isStatic in { name in { generics in { signature in { whereClause in { body in
        FunctionDeclaration(
            isStatic: isStatic != nil,
            name: name,
            arguments: signature.params,
            result: signature.retType,
            hasThrows: signature.hasThrows,
            body: body) }}}}}}
        <^> zeroOrOne(kw_static <* OWS)
        <*> (kw_func *> WS *> identifier)
        <*> zeroOrOne(OWS *> declGenericParams)
        <*> (OWS *> signature)
        <*> zeroOrOne(OWS *> declGenericWhere)
        <*> (OWS *> stmtBrace)
}

fileprivate let declMembers = _declMembers();
fileprivate func _declMembers() -> SwiftParser<[Declaration]> {
    return l_brace *> OWS *> sepEndBy(decl, stmtSep) <* OWS <* r_brace
}

func _declEnum() -> SwiftParser<EnumDeclaration­> {
    return fail("not implemented")
}

func _declStruct() -> SwiftParser<StructDeclaration­> {
    return fail("not implemented")
}

let declClass = _declClass()
func _declClass() -> SwiftParser<ClassDeclaration­> {
    return { name in { generics in { inherits in { whereClause in { members in
        ClassDeclaration­(name: name, superTypes: inherits ?? [], members: members) }}}}}
        <^> (kw_class *> WS *> identifier)
        <*> zeroOrOne(OWS *> declGenericParams)
        <*> zeroOrOne(OWS *> colon *> OWS *> sepBy1(type, OWS *> comma <* OWS))
        <*> zeroOrOne(OWS *> declGenericWhere)
        <*> (OWS *> declMembers)
}

func _declProtocol() -> SwiftParser<ProtocolDeclaration­> {
    return fail("not implemented")
}

let declInitializer = _declInitializer()
func _declInitializer() -> SwiftParser<InitializerDeclaration­> {
    struct Signature {
        let generics: [GenericParam]?
        let params: [Parameter]
        let hasThrows: Bool
        let whereClause: [GenericRequirement]?
    }
    
    let signature = { generics in { params in { hasThrows in { whereClause in
        Signature(generics: generics, params: params, hasThrows: hasThrows != nil, whereClause: whereClause) }}}}
        <^> zeroOrOne(OWS *> declGenericParams)
        <*> (OWS *> list(l_paren, declParam, comma, r_paren))
        <*> zeroOrOne(OWS *> kw_throws)
        <*> zeroOrOne(OWS *> declGenericWhere)
    
    return  { isFailable in { signature in { body in
        InitializerDeclaration­(arguments: signature.params, isFailable: isFailable != nil, hasThrows: signature.hasThrows, body: body) }}}
        <^> (kw_init *> zeroOrOne(char("?")))
        <*> signature
        <*> (OWS *> stmtBrace)
}

func _declDeinitializer() -> SwiftParser<DeinitializerDeclaration­> {
    return fail("not implemented")
}

func _declExtension() -> SwiftParser<ExtensionDeclaration­> {
    return fail("not implemented")
}
