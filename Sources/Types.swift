public protocol Type_ {
    
}

public struct ArrayType: Type_ {
    public var type: Type_
    
    public init(type: Type_) {
        self.type = type
    }
}

public struct DictionaryType: Type_ {
    public var keyType: Type_
    public var valueType: Type_
    
    public init(keyType: Type_, valueType: Type_) {
        self.keyType = keyType
        self.valueType = valueType
    }
}

public struct FunctionType: Type_ {
    public var arguments: [Type_]
    public var returnType: Type_
    
    public init(arguments: [Type_], returnType: Type_) {
        self.arguments = arguments
        self.returnType = returnType
    }
}

public struct TypeIdentifier­: Type_ {
    public var names: [String]
    
    public init(names: [String]) {
        self.names = names
    }
}

public struct TupleType: Type_ {
    public var elements: [(String?, Type_)]
    
    public init(elements: [(String?, Type_)]) {
        self.elements = elements
    }
}

public struct OptionalType: Type_ {
    public var type: Type_
    
    public init(type: Type_) {
        self.type = type
    }
}

public struct ImplicitlyUnwrappedOptionalType: Type_ {
    public var type: Type_
    
    public init(type: Type_) {
        self.type = type
    }
}

public struct ProtocolCompositionType: Type_ {
    public var types: [Type_]
    
    public init(types: [Type_]) {
        self.types = types
    }
}
