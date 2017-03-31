extension JavaScriptTranslator {
    func visit(_ n: IdentifierExpression) throws -> String {
        switch n.identifier {
        case "print":
            return "console.log"
        case "append":
            return "push"
        case "removeLast":
            return "pop"
        default:
            return n.identifier
        }
    }
    
    func visit(_ n: FunctionCallExpression) throws -> String {
        if let expression = n.expression as? PostfixUnaryOperation, expression.operatorSymbol == "?" {
            var node = n
            node.expression = IdentifierExpression(identifier: "x")
            return optionalChaining(expression.operand, node, indentLevel: indentLevel)
        }
        var jsArguments: [String] = n.arguments.map { $1.javaScript(with: indentLevel) }
        if let closure = n.trailingClosure {
            jsArguments.append(closure.javaScript(with: indentLevel))
        }
        let hasNew: Bool
        if let firstLetter = ((n.expression as? IdentifierExpression)?.identifier.characters.first.map { String($0) }) {
            hasNew = firstLetter.uppercased() == firstLetter
        } else {
            hasNew = false
        }
        var jsExpression: String = "\(hasNew ? "new " : "")\(n.expression.javaScript(with: indentLevel))"
        if n.expression is ClosureExpression {
            jsExpression = "(\(jsExpression))"
        }
        return "\(jsExpression)(\(jsArguments.joined(separator: ", ")))"
    }
    
    func visit(_ n: SelfExpression) throws -> String {
        return "this"
    }
    
    func visit(_ n: SuperclassExpression) throws -> String {
        return "super"
    }
    
    func visit(_ n: ClosureExpression) throws -> String {
        let jsArguments: String = n.arguments.map { $0.0 }.joined(separator: ", ")
        switch n.statements.count {
        case 0:
            return "(\(jsArguments)) => {}"
        case 1:
            let statement = n.statements[0]
            if let expressionStatement = statement as? ExpressionStatement {
                return "(\(jsArguments)) => \(expressionStatement.expression.javaScript(with: indentLevel))"
            } else {
                return "(\(jsArguments)) => \(transpileBlock(statements: n.statements, indentLevel: indentLevel))"
            }
        default:
            return "(\(jsArguments)) => \(transpileBlock(statements: n.statements, indentLevel: indentLevel))"
        }
    }
    
    func visit(_ n: ParenthesizedExpression) throws -> String {
        return "(\(n.expression.javaScript(with: indentLevel + 1)))"
    }
    
    func visit(_ n: TupleExpression) throws -> String {
        let values = n.elements.map { $0.1.javaScript(with: indentLevel + 1) }.joined(separator: ", ")
        return "[\(values)]"
    }
    
    func visit(_: ImplicitMemberExpression) throws -> String {
        throw UnimplementedError()
    }

    func visit(_ n: WildcardExpression) throws -> String {
        return "_"
    }
    
    func visit(_: InitializerExpression) throws -> String {
        throw UnimplementedError()
    }
    
    func visit(_ n: ExplicitMemberExpression) throws -> String {
        if let expression = n.expression as? PostfixUnaryOperation, expression.operatorSymbol == "?" {
            var node = n
            node.expression = IdentifierExpression(identifier: "x")
            return optionalChaining(expression.operand, node, indentLevel: indentLevel)
        }
        if n.expression is SuperclassExpression, n.member == "init" {
            return "\(n.expression.javaScript(with: indentLevel))"
        }
        return "\(n.expression.javaScript(with: indentLevel)).\(n.member)"
    }
    
    func visit(_: PostfixSelfExpression) throws -> String {
        throw UnimplementedError()
    }
    
    func visit(_: DynamicTypeExpression) throws -> String {
        throw UnimplementedError()
    }

    func visit(_ n: SubscriptExpression) throws -> String {
        if let expression = n.expression as? PostfixUnaryOperation, expression.operatorSymbol == "?" {
            var node = n
            node.expression = IdentifierExpression(identifier: "x")
            return optionalChaining(expression.operand, node, indentLevel: indentLevel)
        }
        var jsExpression = n.expression.javaScript(with: indentLevel)
        if n.expression is ClosureExpression {
            jsExpression = "(\(jsExpression))"
        }
        return "\(jsExpression)[\(n.arguments.map { $0.javaScript(with: indentLevel) }.joined(separator: ", "))]"
    }
}

private func optionalChaining(_ primary: Expression, _ secondary: Expression, indentLevel: Int) -> String {
    return "q(\(primary.javaScript(with: indentLevel)), (x) => \(secondary.javaScript(with: indentLevel)))"
}
