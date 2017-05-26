import SwiftAST

extension KotlinTranslator {
    func visit(_ n: BinaryOperation) throws -> String {
        let lhs = try n.leftOperand.accept(self)
        let rhs = try n.rightOperand.accept(self)
        switch n.operatorSymbol {
        case "as":
            return "\(lhs) as \(lhs)"
        case "as?":
            return "\(lhs) as? \(lhs)"
        case "as!":
            return "\(lhs) as \(lhs)"
        case "is":
            return "\(lhs) is \(rhs)"
        case "??":
            return "\(lhs) ?: \(rhs)"
        case "...":
            return "\(lhs)..\(rhs)"
        case "..<":
            return "\(lhs)..<\(rhs)" // TODO
        case "&&=", "||=":
            return "\(lhs) = \(lhs) \(n.operatorSymbol) \(rhs)" // TODO
        default:
            return "\(lhs) \(n.operatorSymbol) \(rhs)"
        }
    }
    
    func visit(_ n: PrefixUnaryOperation) throws -> String {
        let value = try n.operand.accept(self)
        switch n.operatorSymbol {
        case "try":
            return value
        case "try!":
            return "tryx(\(value))"
        case "try?":
            return "tryq(\(value))"
        default:
            return "\(n.operatorSymbol)\(value)"
        }
    }
    
    func visit(_ n: PostfixUnaryOperation) throws -> String {
        let value = try n.operand.accept(self)
        switch n.operatorSymbol {
        case "?":
            fatalError("Never reaches here if semantic analysis is implemented.")
        case "!":
            return "x(\(value))"
        default:
            return "\(value)\(n.operatorSymbol)"
        }
    }
    
    func visit(_ n: TernaryOperation) throws -> String {
        let first = try n.firstOperand.accept(self)
        let second = try n.secondOperand.accept(self)
        let third = try n.thirdOperand.accept(self)
        return "\(first) ? \(second) : \(third)"
    }
}
