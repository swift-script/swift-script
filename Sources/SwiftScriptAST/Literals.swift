public protocol Literal: Expression {
    
}

public struct ArrayLiteral: Literal {
    public var value: [Expression]
}

public struct DictionaryLiteral: Literal {
    public var value: [(Expression, Expression)]
}

public struct IntegerLiteral: Literal {
    public var value: Int
}

public struct FloatingPointLiteral: Literal {
    public var value: Float
}

public struct StringLiteral: Literal {
    public var value: String
}

public struct BooleanLiteral: Literal {
    public var value: Bool
}

public struct NilLiteral: Literal {
    
}
