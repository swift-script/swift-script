extension IdentifierExpression {
    public func javaScript(with indentLevel: Int) -> String {
        switch identifier {
            case "print":
                return "console.log"
            case "append":
                return "push"
            case "removeLast":
                return "pop"
            default:
                return identifier
        }
    }
}

extension FunctionCallExpression {
    public func javaScript(with indentLevel: Int) -> String {
        var jsArguments: [String] = arguments.map { $1.javaScript(with: indentLevel) }
        if let closure = trailingClosure {
            jsArguments.append(closure.javaScript(with: indentLevel))
        }
        let hasNew: Bool
        if let firstLetter = ((expression as? IdentifierExpression)?.identifier.characters.first.map { String($0) }) {
            hasNew = firstLetter.uppercased() == firstLetter
        } else {
            hasNew = false
        }
        return "\(hasNew ? "new " : "")\(expression.javaScript(with: indentLevel))(\(jsArguments.joined(separator: ", ")))"
    }
}

extension SelfExpression {
    public func javaScript(with indentLevel: Int) -> String {
        return "this"
    }
}

extension SuperclassExpression {
    public func javaScript(with indentLevel: Int) -> String {
        return "super"
    }
}

extension ClosureExpression {
    public func javaScript(with indentLevel: Int) -> String {
        let jsArguments: String = arguments.map { $0.0 }.joined(separator: ", ")
        switch statements.count {
        case 0:
            return "(\(jsArguments)) => {}"
        case 1:
            let statement = statements[0]
            if statement is Expression {
                return "(\(jsArguments)) => \(statement.javaScript(with: indentLevel))"
            } else {
                return "(\(jsArguments)) => \(transpileBlock(statements: statements, indentLevel: indentLevel))"
            }
        default:
            return "(\(jsArguments)) => \(transpileBlock(statements: statements, indentLevel: indentLevel))"
        }
    }
}

extension ParenthesizedExpression {
    public func javaScript(with indentLevel: Int) -> String {
        return "(\(expression.javaScript(with: indentLevel + 1)))"
    }
}

extension TupleExpression {
    public func javaScript(with indentLevel: Int) -> String {
        let values = elements.map { $0.1.javaScript(with: indentLevel + 1) }.joined(separator: ", ")
        return "[\(values)]"
    }
}

extension WildcardExpression {
    public func javaScript(with indentLevel: Int) -> String {
        return "_"
    }
}

extension ExplicitMemberExpression {
    public func javaScript(with indentLevel: Int) -> String {
        if expression is SuperclassExpression, member == "init" {
            return "\(expression.javaScript(with: indentLevel))"
        }
        return "\(expression.javaScript(with: indentLevel)).\(member)"
    }
}

extension SubscriptExpression {
    public func javaScript(with indentLevel: Int) -> String {
        let variable = expression.javaScript(with: indentLevel + 1)
        let args = arguments.map { $0.javaScript(with: indentLevel + 1) }.joined(separator: ", ")
        return "\(variable)[\(args)]"
    }
}

extension OptionalChainingExpression {
    public func javaScript(with indentLevel: Int) -> String {
        let exp = expression.javaScript(with: indentLevel + 1)
        return "q(\(exp), (x) => x.\(member)"
    }
}
