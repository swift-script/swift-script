public protocol Literal: Expression {
    
}

public struct ArrayLiteral: Literal {
    public var value: [Expression]
    
    public init(value: [Expression]) {
        self.value = value
    }
}

public struct DictionaryLiteral: Literal {
    public var value: [(Expression, Expression)]
    
    public init(value: [(Expression, Expression)]) {
        self.value = value
    }
}

public struct IntegerLiteral: Literal {
    public var value: Int
    
    public init(value: Int) {
        self.value = value
    }
}

public struct FloatingPointLiteral: Literal {
    public var value: Float
    
    public init(value: Float) {
        self.value = value
    }
}

public struct StringLiteral: Literal {
    public var value: String
    
    public init(value: String) {
        self.value = value
    }
}

public struct InterpolatedStringLiteral: Literal {
    public var segments: [Expression]

    public init(segments: [Expression]) {
        self.segments = segments
    }
}

public struct BooleanLiteral: Literal {
    public var value: Bool

    public init(value: Bool) {
        self.value = value
    }
}

public struct NilLiteral: Literal {
    public init() {}
}
