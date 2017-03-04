extension BinaryOperation {
    public func javaScript(with indentLevel: Int) -> String {
        let lhs = leftOperand.javaScript(with: indentLevel + 1)
        let rhs = rightOperand.javaScript(with: indentLevel + 1)
        switch operatorSymbol {
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
            return "\(lhs) = \(lhs) \(operatorSymbol) \(rhs)"
        default:
            return "\(lhs) \(operatorSymbol) \(rhs)"
        }
    }
}

extension PrefixUnaryOperation {
    public func javaScript(with indentLevel: Int) -> String {
        let value = operand.javaScript(with: indentLevel + 1)
        switch operatorSymbol {
        case "try":
            return value
        case "try!":
            return "tryx(\(value))"
        case "try?":
            return "tryq(\(value))"
        default:
            return "\(operatorSymbol)\(value)"
        }
    }
}

extension PostfixUnaryOperation {
    public func javaScript(with indentLevel: Int) -> String {
        let value = operand.javaScript(with: indentLevel + 1)
        switch operatorSymbol {
        case "?":
            return "q(\(value))"
        case "!":
            return "x(\(value))"
        default:
            return "\(value)\(operatorSymbol)"
        }
    }
}

extension TernaryOperation {
    public func javaScript(with indentLevel: Int) -> String {
        let first = firstOperand.javaScript(with: indentLevel + 1)
        let second = secondOperand.javaScript(with: indentLevel + 1)
        let third = thirdOperand.javaScript(with: indentLevel + 1)
        return "\(first) ? \(second) : \(third)"
    }
}
