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
        let f = expression.javaScript(with: indentLevel + 1)
        var args = arguments.map { $1.javaScript(with: indentLevel + 1) }
        if let closure = trailingClosure {
            args.append(closure.javaScript(with: indentLevel + 1))
        }
        let argsString = args.joined(separator: ", ")
        return "\(f)(\(argsString))"
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
        let args = (arguments.map { $0.0 }).joined(separator: ", ")
        let lines = transpileStatements(statements: statements, indentLevel: indentLevel)
        switch statements.count {
        case 0:
            return "(\(args)) => {}"
        case 1:
            return "(\(args)) => \(lines)"
        default:
            let spaces = String(repeating: "    ", count: indentLevel)
            return "(\(args)) => {\n\(lines)\n\(spaces)}"
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
        let variable = expression.javaScript(with: indentLevel + 1)
        return "\(variable).\(member)"
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
