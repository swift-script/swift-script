public protocol Expression: Statement {
    
}

public struct IdentifierExpression: Expression {
    var identifier: String
}

public struct SelfExpression: Expression {
    
}

public struct SuperclassExpression: Expression {
    
}

public struct ClosureExpression: Expression {
    // TODO
}

public struct ParenthesizedExpression: Expression {
    var expression: Expression
}

public struct TupleExpression: Expression {
    var elements: [(String?, Expression)]
}

public struct ImplicitMemberExpression: Expression {
    // Unsupported
}

public struct WildcardExpression: Expression {
    
}

public struct FunctionCallExpression: Expression {
    var arguments: [(String?, Expression)]
    var trailingClosure: ClosureExpression?
}

public struct InitializerExpression: Expression {
    
}

public struct ExplicitMemberExpression: Expression {
    var expression: Expression
    var member: String
}

public struct PostfixSelfExpression: Expression {
    // Unsupported
}

public struct DynamicTypeExpression: Expression {
    var expression: Expression
}

public struct SubscriptExpression: Expression {
    var expression: Expression
    var arguments: [Expression]
}

public struct OptionalChainingExpression: Expression {
    var expression: Expression
    var member: String
}

