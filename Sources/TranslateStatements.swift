extension ForInStatement {
    public func javaScript(with indentLevel: Int) -> String {
        return "\(indent(of: indentLevel))for (\(item) of \(collection.javaScript(with: indentLevel))) \(transpileBlock(statements: statements, indentLevel: indentLevel))\n"
    }
}

extension IfStatement {
    public func javaScript(with indentLevel: Int) -> String {
        return "\(indent(of: indentLevel))\(_javaScript(with: indentLevel))"
    }
    
    private func _javaScript(with indentLevel: Int) -> String {
        let jsIf = "if (\(self.condition.javaScript(with: indentLevel))) \(transpileBlock(statements: statements, indentLevel: indentLevel))"
        guard let elseClause = self.elseClause else {
            return "\(jsIf)\n"
        }
        switch elseClause {
        case let .elseIf(ifStatement):
            return "\(jsIf) else \(ifStatement._javaScript(with: indentLevel))"
        case let .else_(statements):
            return "\(jsIf) else \(transpileBlock(statements: statements, indentLevel: indentLevel))\n"
        }
    }
}

extension GuardStatement {
    public func javaScript(with indentLevel: Int) -> String {
        return IfStatement(
            condition: PrefixUnaryOperation(operatorSymbol: "!", operand: ParenthesizedExpression(expression: condition)),
            statements: statements,
            elseClause: nil
        ).javaScript(with: indentLevel)
    }
}

extension ReturnStatement {
    public func javaScript(with indentLevel: Int) -> String {
        if let expression = expression {
            return "\(indent(of: indentLevel))return \(expression.javaScript(with: indentLevel));\n"
        } else {
            return "\(indent(of: indentLevel))return;\n"
        }
    }
}
