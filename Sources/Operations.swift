public protocol Operation: Expression {
    
}

public struct BinaryOperation: Operation {
    public var leftOperand: Expression
    public var operatorSymbol: String
    public var rightOperand: Expression
}

public struct PrefixUnaryOperation: Operation {
    public var operatorSymbol: String
    public var operand: Expression
}

public struct PostfixUnaryOperation: Operation {
    public var operand: Expression
    public var operatorSymbol: String
}

public struct TernaryOperation: Operation {
    public var firstOperand: Expression
    public var secondOperand: Expression
    public var thirdOperand: Expression
}
