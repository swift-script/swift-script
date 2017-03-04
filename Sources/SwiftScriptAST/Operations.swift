public protocol Operation: Expression {
    
}

public struct BinaryOperation: Operation {
    var leftOperand: Expression
    var operatorSymbol: String
    var rightOperand: Expression
}

public struct PrefixUnaryOperation: Operation {
    var operatorSymbol: String
    var operand: Expression
}

public struct PostfixUnaryOperation: Operation {
    var operand: Expression
    var operatorSymbol: String
}

public struct TernaryOperation: Operation {
    var firstOperand: Expression
    var secondOperand: Expression
    var thirdOperand: Expression
}
