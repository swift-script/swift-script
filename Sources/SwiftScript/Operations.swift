import SwiftAST

extension JavaScriptTranslator {
    func visit(_ n: BinaryOperation) throws -> String {
        let lhs = try n.leftOperand.accept(self)
        let rhs = try n.rightOperand.accept(self)
        switch n.operatorSymbol {
        case "as":
            return lhs
        case "as?":
            return "asq(\(lhs), \(lhs) => is(\(lhs), \(rhs)))"
        case "as!":
            return "asx(\(lhs), \(lhs) => is(\(lhs), \(rhs)))"
        case "is":
            return "is(\(lhs), \(rhs))"
        case "??":
            return "qq(\(lhs), \(rhs))"
        case "...":
            return "closedRange(\(lhs), \(rhs))"
        case "..<":
            return "range(\(lhs), \(rhs))" // TODO: should make specific range function
        case "&&=", "||=":
            return "\(lhs) = \(lhs) \(n.operatorSymbol) \(rhs)"
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
