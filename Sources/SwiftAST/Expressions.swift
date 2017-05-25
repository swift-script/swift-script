public protocol Expression {
    func accept<V: ExpressionVisitor>(_: V) throws -> V.ExpressionResult
}

public struct IdentifierExpression: Expression {
    public var identifier: String
    
    public init(identifier: String) {
        self.identifier = identifier
    }
}

public struct SelfExpression: Expression {
    public init() {}
}

public struct SuperclassExpression: Expression {
    public init() {}
}

public struct ClosureExpression: Expression {
    public var arguments: [(String, Type_?)]
    public var hasThrows: Bool
    public var result: Type_?
    public var statements: [Statement]
    
    public init(arguments: [(String, Type_?)], hasThrows: Bool, result: Type_?, statements: [Statement]) {
        self.arguments = arguments
        self.hasThrows = hasThrows
        self.result = result
        self.statements = statements
    }
}

public struct ParenthesizedExpression: Expression {
    public var expression: Expression
    
    public init(expression: Expression) {
        self.expression = expression
    }
}

public struct TupleExpression: Expression {
    public var elements: [(String?, Expression)]
    
    public init(elements: [(String?, Expression)]) {
        self.elements = elements
    }
}

public struct ImplicitMemberExpression: Expression {
    // Unsupported
    public init() {}
}

public struct WildcardExpression: Expression {
    public init() {}
}

public struct FunctionCallExpression: Expression {
    public var expression: Expression
    public var arguments: [(String?, Expression)]
    public var trailingClosure: ClosureExpression?
    
    public init(expression: Expression, arguments: [(String?, Expression)], trailingClosure: ClosureExpression?) {
        self.expression = expression
        self.arguments = arguments
        self.trailingClosure = trailingClosure
    }
}

public struct InitializerExpression: Expression {
    /// e.g. `SelfExpression`, `SuperclassExpression`.
    public var postfixExpression: Expression

    public init(postfixExpression: Expression) {
        self.postfixExpression = postfixExpression
    }
}

public struct ExplicitMemberExpression: Expression {
    public var expression: Expression
    public var member: String
    
    public init(expression: Expression, member: String) {
        self.expression = expression
        self.member = member
    }
}

public struct PostfixSelfExpression: Expression {
    // Unsupported
    public init() {}
}

public struct DynamicTypeExpression: Expression {
    public var expression: Expression
    
    public init(expression: Expression) {
        self.expression = expression
    }
}

public struct SubscriptExpression: Expression {
    public var expression: Expression
    public var arguments: [Expression]
    
    public init(expression: Expression, arguments: [Expression]) {
        self.expression = expression
        self.arguments = arguments
    }
}
