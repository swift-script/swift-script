public protocol Operation: Expression {
    
}

public struct BinaryOperation: Operation {
    public var leftOperand: Expression
    public var operatorSymbol: String
    public var rightOperand: Expression
    
    public init(leftOperand: Expression, operatorSymbol: String, rightOperand: Expression) {
        self.leftOperand = leftOperand
        self.operatorSymbol = operatorSymbol
        self.rightOperand = rightOperand
    }
}

public struct PrefixUnaryOperation: Operation {
    public var operatorSymbol: String
    public var operand: Expression
    
    public init(operatorSymbol: String, operand: Expression) {
        self.operatorSymbol = operatorSymbol
        self.operand = operand
    }
}

public struct PostfixUnaryOperation: Operation {
    public var operand: Expression
    public var operatorSymbol: String
    
    public init(operand: Expression, operatorSymbol: String) {
        self.operatorSymbol = operatorSymbol
        self.operand = operand
    }
}

public struct TernaryOperation: Operation {
    public var firstOperand: Expression
    public var secondOperand: Expression
    public var thirdOperand: Expression

    public init(firstOperand: Expression, secondOperand: Expression, thirdOperand: Expression) {
        self.firstOperand = firstOperand
        self.secondOperand = secondOperand
        self.thirdOperand = thirdOperand
    }
}
