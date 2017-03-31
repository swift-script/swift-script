extension JavaScriptTranslator {
    func visit(_ n: BinaryOperation) throws -> String {
        let lhs = n.leftOperand.javaScript(with: indentLevel + 1)
        let rhs = n.rightOperand.javaScript(with: indentLevel + 1)
        switch n.operatorSymbol {
        case "as":
            return lhs
        case "as?":
            return "asq(\(lhs), \(lhs) => is(\(lhs), \(rhs)))"
        case "as!":
            return "asx(\(lhs), \(lhs) => is(\(lhs), \(rhs)))"
        case "is":
            return "is(\(lhs), \(rhs)"
        case "??":
            return "qq(\(lhs), \(rhs)"
        case "...":
            return "closedRange(\(lhs), \(rhs)"
        case "..<":
            return "range(\(lhs), \(rhs)" // TODO: should make specific range function
        case "&&=", "||=":
            return "\(lhs) = \(lhs) \(n.operatorSymbol) \(rhs)"
        default:
            return "\(lhs) \(n.operatorSymbol) \(rhs)"
        }
    }
    
    func visit(_ n: PrefixUnaryOperation) throws -> String {
        let value = n.operand.javaScript(with: indentLevel + 1)
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
        let value = n.operand.javaScript(with: indentLevel + 1)
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
        let first = n.firstOperand.javaScript(with: indentLevel + 1)
        let second = n.secondOperand.javaScript(with: indentLevel + 1)
        let third = n.thirdOperand.javaScript(with: indentLevel + 1)
        return "\(first) ? \(second) : \(third)"
    }
}
