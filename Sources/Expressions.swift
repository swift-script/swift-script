public protocol Expression: Statement {
    
}

public struct IdentifierExpression: Expression {
    public var identifier: String
}

public struct SelfExpression: Expression {
    
}

public struct SuperclassExpression: Expression {
    
}

public struct ClosureExpression: Expression {
    public var arguments: [(String, Type_?)]
    public var hasThrows: Bool
    public var result: Type_?
    public var statements: [Statement]
}

public struct ParenthesizedExpression: Expression {
    public var expression: Expression
}

public struct TupleExpression: Expression {
    public var elements: [(String?, Expression)]
}

public struct ImplicitMemberExpression: Expression {
    // Unsupported
}

public struct WildcardExpression: Expression {
    
}

public struct FunctionCallExpression: Expression {
    public var expression: Expression
    public var arguments: [(String?, Expression)]
    public var trailingClosure: ClosureExpression?
}

public struct InitializerExpression: Expression {
    
}

public struct ExplicitMemberExpression: Expression {
    public var expression: Expression
    public var member: String
}

public struct PostfixSelfExpression: Expression {
    // Unsupported
}

public struct DynamicTypeExpression: Expression {
    public var expression: Expression
}

public struct SubscriptExpression: Expression {
    public var expression: Expression
    public var arguments: [Expression]
}

public struct OptionalChainingExpression: Expression {
    public var expression: Expression
    public var member: String
}

