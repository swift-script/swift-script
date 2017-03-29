public protocol Type_ {
    func accept<V: TypeVisitor>(_: V) throws -> V.TypeResult
}

public struct ArrayType: Type_ {
    public var type: Type_
}

public struct DictionaryType: Type_ {
    public var keyType: Type_
    public var valueType: Type_
}

public struct FunctionType: Type_ {
    public var arguments: [Type_]
    public var returnType: Type_
}

public struct TypeIdentifier­: Type_ {
    public var names: [String]
}

public struct TupleType: Type_ {
    public var elements: [(String?, Type_)]
}

public struct OptionalType: Type_ {
    public var type: Type_
}

public struct ImplicitlyUnwrappedOptionalType: Type_ {
    public var type: Type_
}

public struct ProtocolCompositionType: Type_ {
    public var types: [Type_]
}
