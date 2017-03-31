public protocol Declaration: Node {
    func accept<V: DeclarationVisitor>(_: V) throws -> V.DeclarationResult
}

public struct ImportDeclaration: Declaration {
    // Unsupported
    public init() {}
}

public struct ConstantDeclaration: Declaration {
    public var isStatic: Bool
    public var name: String
    public var type: Type_?
    public var expression: Expression?
    
    public init(isStatic: Bool, name: String, type: Type_?, expression: Expression?) {
        self.isStatic = isStatic
        self.name = name
        self.type = type
        self.expression = expression
    }
}


public struct VariableDeclaration: Declaration {
    public var isStatic: Bool
    public var name: String
    public var type: Type_?
    public var expression: Expression?
    // TODO: Computed Property
    
    public init(isStatic: Bool, name: String, type: Type_?, expression: Expression?) {
        self.isStatic = isStatic
        self.name = name
        self.type = type
        self.expression = expression
    }
}


public struct TypeAliasDeclaration: Declaration {
    public var name: String
    public var type: Type_
    
    public init(name: String, type: Type_) {
        self.name = name
        self.type = type
    }
}

public struct Parameter {
    public var externalParameterName: String?
    public var localParameterName: String
    public var type: Type_
    public var defaultArgument: Expression?
    
    public init(externalParameterName: String?, localParameterName: String, type: Type_, defaultArgument: Expression?) {
        self.externalParameterName = externalParameterName
        self.localParameterName = localParameterName
        self.type = type
        self.defaultArgument = defaultArgument
    }
}

public struct FunctionDeclaration: Declaration {
    public var isStatic: Bool
    public var name: String
    public var arguments: [Parameter]
    public var result: Type_?
    public var hasThrows: Bool
    public var body: [Statement]?
    
    public init(isStatic: Bool, name: String, arguments: [Parameter], result: Type_?, hasThrows: Bool, body: [Statement]?) {
        self.isStatic = isStatic
        self.name = name
        self.arguments = arguments
        self.result = result
        self.hasThrows = hasThrows
        self.body = body
    }
}


public struct EnumDeclaration­: Declaration {
    // Unsupported
    public init() {}
}


public struct StructDeclaration­: Declaration {
    // Unsupported
    public init() {}
}


public struct ClassDeclaration­: Declaration {
    public var name: String
    public var superTypes: [Type_]
    public var members: [Declaration]
    
    public init(name: String, superTypes: [Type_], members: [Declaration]) {
        self.name = name
        self.superTypes = superTypes
        self.members = members
    }
}


public struct ProtocolDeclaration­: Declaration {
    public var name: String
    // Only `name` is used
    
    public init(name: String) {
        self.name = name
    }
}


public struct InitializerDeclaration­: Declaration {
    public var arguments: [Parameter]
    public var isFailable: Bool
    public var hasThrows: Bool
    public var body: [Statement]?
    
    public init(arguments: [Parameter], isFailable: Bool, hasThrows: Bool, body: [Statement]?) {
        self.arguments = arguments
        self.isFailable = isFailable
        self.hasThrows = hasThrows
        self.body = body
    }
}

public struct DeinitializerDeclaration­: Declaration {
    // Unsupported
    public init() {}
}


public struct ExtensionDeclaration­: Declaration {
    // TODO
    public init() {}
}


public struct SubscriptDeclaration­: Declaration {
    // Unsupported
    public init() {}
}


public struct OperatorDeclaration­: Declaration {
    // Unsupported
    public init() {}
}


public struct PrecedenceGroupDeclaration­: Declaration {
    // Unsupported
    public init() {}
}
