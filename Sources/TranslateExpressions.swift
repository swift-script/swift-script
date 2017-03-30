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
        if let expression = expression as? PostfixUnaryOperation, expression.operatorSymbol == "?" {
            var zelf = self
            zelf.expression = IdentifierExpression(identifier: "x")
            return optionalChaining(expression.operand, zelf, indentLevel: indentLevel)
        }
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
        var jsExpression: String = "\(hasNew ? "new " : "")\(expression.javaScript(with: indentLevel))"
        if expression is ClosureExpression {
            jsExpression = "(\(jsExpression))"
        }
        return "\(jsExpression)(\(jsArguments.joined(separator: ", ")))"
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
            if let exprStmt = statement as? ExprStatement {
                return "(\(jsArguments)) => \(exprStmt.expression.javaScript(with: indentLevel))"
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
        if let expression = expression as? PostfixUnaryOperation, expression.operatorSymbol == "?" {
            var zelf = self
            zelf.expression = IdentifierExpression(identifier: "x")
            return optionalChaining(expression.operand, zelf, indentLevel: indentLevel)
        }
        if expression is SuperclassExpression, member == "init" {
            return "\(expression.javaScript(with: indentLevel))"
        }
        return "\(expression.javaScript(with: indentLevel)).\(member)"
    }
}

extension SubscriptExpression {
    public func javaScript(with indentLevel: Int) -> String {
        if let expression = expression as? PostfixUnaryOperation, expression.operatorSymbol == "?" {
            var zelf = self
            zelf.expression = IdentifierExpression(identifier: "x")
            return optionalChaining(expression.operand, zelf, indentLevel: indentLevel)
        }
        var jsExpression = expression.javaScript(with: indentLevel)
        if expression is ClosureExpression {
            jsExpression = "(\(jsExpression))"
        }
        return "\(jsExpression)[\(arguments.map { $0.javaScript(with: indentLevel) }.joined(separator: ", "))]"
    }
}

private func optionalChaining(_ primary: Expression, _ secondary: Expression, indentLevel: Int) -> String {
    return "q(\(primary.javaScript(with: indentLevel)), (x) => \(secondary.javaScript(with: indentLevel)))"
}
