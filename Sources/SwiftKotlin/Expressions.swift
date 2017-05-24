import SwiftAST

extension KotlinTranslator {
    func visit(_ n: IdentifierExpression) throws -> String {
        switch n.identifier {
        case "$0":
            return "it" // TODO: Consider `"$N"` (N = 1,2,...).
        default:
            return n.identifier
        }
    }
    
    func visit(_ n: FunctionCallExpression) throws -> String {
        if let expression = n.expression as? PostfixUnaryOperation, expression.operatorSymbol == "?" {
            return "\(try expression.operand.accept(self))?.\(try n.accept(self))"
        }
        var arguments: [String] = try n.arguments.map { paramName, expr in
            let value = try expr.accept(self)
            if let paramName = paramName {
                return "\(paramName) = \(value)"
            } else {
                return "\(value)"
            }
        }
        if let closure = n.trailingClosure {
            arguments.append(try closure.accept(self))
        }

        var expression: String = "\(try n.expression.accept(self))"
        if n.expression is ClosureExpression {
            expression = "(\(expression))"
        }
        return "\(expression)(\(arguments.joined(separator: ", ")))"
    }
    
    func visit(_ n: SelfExpression) throws -> String {
        return "this"
    }
    
    func visit(_ n: SuperclassExpression) throws -> String {
        return "super"
    }
    
    func visit(_ n: ClosureExpression) throws -> String {
        let arguments: String = n.arguments.map { $0.0 }.joined(separator: ", ")
        let argumentsWithArrow = arguments.isEmpty ? "" : " \(arguments) ->"

        switch n.statements.count {
        case 0:
            return "{\(argumentsWithArrow)}"
        case 1:
            let statement = n.statements[0]
            if let expressionStatement = statement as? ExpressionStatement {
                return "{\(argumentsWithArrow) \(try expressionStatement.expression.accept(self)) }"
            } else {
                return "{\(argumentsWithArrow)\n\(try translate(n.statements, with: indentLevel + 1))\(indent(of: indentLevel))}"
            }
        default:
            return "{\(argumentsWithArrow)\n\(try translate(n.statements, with: indentLevel + 1))\(indent(of: indentLevel))}"
        }
    }
    
    func visit(_ n: ParenthesizedExpression) throws -> String {
        return "(\(try n.expression.accept(self)))"
    }
    
    func visit(_ n: TupleExpression) throws -> String {
        let values = try n.elements.map { try $0.1.accept(self) }.joined(separator: ", ")
        return "[\(values)]"
    }
    
    func visit(_: ImplicitMemberExpression) throws -> String {
        throw UnimplementedError()
    }

    func visit(_ n: WildcardExpression) throws -> String {
        return "_"
    }

    func visit(_ n: InitializerExpression) throws -> String {
        return try n.receiverExpression.accept(self)
    }
    
    func visit(_ n: ExplicitMemberExpression) throws -> String {
        if let expression = n.expression as? PostfixUnaryOperation, expression.operatorSymbol == "?" {
            return "\(try expression.operand.accept(self))?.\(n.member)"
        }
        if n.expression is SuperclassExpression, n.member == "init" {
            return "\(try n.expression.accept(self))"
        }
        return "\(try n.expression.accept(self)).\(n.member)"
    }
    
    func visit(_: PostfixSelfExpression) throws -> String {
        throw UnimplementedError()
    }
    
    func visit(_: DynamicTypeExpression) throws -> String {
        throw UnimplementedError()
    }

    func visit(_ n: SubscriptExpression) throws -> String {
        if let expression = n.expression as? PostfixUnaryOperation, expression.operatorSymbol == "?" {
            return "\(try expression.operand.accept(self))?.\(try n.accept(self))"
        }
        var jsExpression = try n.expression.accept(self)
        if n.expression is ClosureExpression {
            jsExpression = "(\(jsExpression))"
        }
        return "\(jsExpression)[\(try n.arguments.map { try $0.accept(self) }.joined(separator: ", "))]"
    }
}
