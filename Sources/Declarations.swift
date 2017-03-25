public protocol Declaration: Node {
    
}

public struct ImportDeclaration: Declaration {
    // Unsupported
}

public struct ConstantDeclaration: Declaration {
    public var isStatic: Bool
    public var name: String
    public var type: Type_?
    public var expression: Expression?
}


public struct VariableDeclaration: Declaration {
    public var isStatic: Bool
    public var name: String
    public var type: Type_?
    public var expression: Expression?
    // TODO: Computed Property
}


public struct TypeAliasDeclaration: Declaration {
    public var name: String
    public var type: Type_
}

public struct Parameter {
    public var externalParameterName: String?
    public var localParameterName: String
    public var type: Type_
    public var defaultArgument: Expression?
}

public struct FunctionDeclaration: Declaration {
    public var isStatic: Bool
    public var name: String
    public var arguments: [Parameter]
    public var result: Type_?
    public var hasThrows: Bool
    public var body: [Statement]?
}


public struct EnumDeclaration­: Declaration {
    // Unsupported
}


public struct StructDeclaration­: Declaration {
    // Unsupported
}


public struct ClassDeclaration­: Declaration {
    public var name: String
    public var superTypes: [Type_]
    public var members: [Declaration]
}


public struct ProtocolDeclaration­: Declaration {
    public var name: String
    // Only `name` is used
}


public struct InitializerDeclaration­: Declaration {
    public var arguments: [Parameter]
    public var isFailable: Bool
    public var hasThrows: Bool
    public var body: [Statement]?
}

public struct DeinitializerDeclaration­: Declaration {
    // Unsupported
}


public struct ExtensionDeclaration­: Declaration {
    // TODO
}


public struct SubscriptDeclaration­: Declaration {
    // Unsupported
}


public struct OperatorDeclaration­: Declaration {
    // Unsupported
}


public struct PrecedenceGroupDeclaration­: Declaration {
    // Unsupported
}
