public protocol Literal: Expression {
    
}

public struct ArrayLiteral: Literal {
    var value: [Expression]
}

public struct DictionaryLiteral: Literal {
    var value: [(Expression, Expression)]
}

public struct IntegerLiteral: Literal {
    var value: Int
}

public struct FloatingPointLiteral: Literal {
    var value: Float
}

public struct StringLiteral: Literal {
    var value: String
}

public struct BooleanLiteral: Literal {
    var value: Bool
}

public struct NilLiteral: Literal {
    
}
