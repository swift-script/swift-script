extension ForInStatement {
    public func javaScript(with indentLevel: Int) -> String {
        return "\(indent(of: indentLevel))for (\(item) of \(collection.javaScript(with: indentLevel))) \(transpileBlock(statements: statements, indentLevel: indentLevel))\n"
    }
}

extension WhileStatement {
    public func javaScript(with indentLevel: Int) -> String {
        return "\(indent(of: indentLevel))while (\(condition.javaScript(with: indentLevel))) \(transpileBlock(statements: statements, indentLevel: indentLevel))\n"
    }
}

extension RepeatWhileStatement {
    public func javaScript(with indentLevel: Int) -> String {
        return "\(indent(of: indentLevel))repeat \(transpileBlock(statements: statements, indentLevel: indentLevel)) while (\(condition.javaScript(with: indentLevel)))\n"
    }
}

extension IfStatement {
    public func javaScript(with indentLevel: Int) -> String {
        return "\(indent(of: indentLevel))\(_javaScript(with: indentLevel))"
    }
    
    private func _javaScript(with indentLevel: Int) -> String {
        let jsIf: String
        switch condition {
        case let .boolean(expression):
            jsIf = "if (\(expression.javaScript(with: indentLevel))) \(transpileBlock(statements: statements, indentLevel: indentLevel))"
            guard let elseClause = self.elseClause else {
                return "\(jsIf)\n"
            }
            switch elseClause {
            case let .elseIf(ifStatement):
                return "\(jsIf) else \(ifStatement._javaScript(with: indentLevel))"
            case let .else_(statements):
                return "\(jsIf) else \(transpileBlock(statements: statements, indentLevel: indentLevel))\n"
            }
        case let .optionalBinding(_, name, expression):
            if let expression = expression as? IdentifierExpression, expression.identifier == name {
                return IfStatement(
                    condition: .boolean(BinaryOperation(
                        leftOperand: IdentifierExpression(identifier: name),
                        operatorSymbol: "!=",
                        rightOperand: NilLiteral()
                    )),
                    statements: statements,
                    elseClause: elseClause
                ).javaScript(with: indentLevel)
            }
            
            return DoStatement(statements: [
                VariableDeclaration(isStatic: false, name: name, type: nil, expression: nil),
                IfStatement(
                    condition: .boolean(BinaryOperation(
                        leftOperand: ParenthesizedExpression(expression: BinaryOperation(
                            leftOperand: IdentifierExpression(identifier: name),
                            operatorSymbol: "=",
                            rightOperand: expression
                        )),
                        operatorSymbol: "!=",
                        rightOperand: NilLiteral()
                    )),
                    statements: statements,
                    elseClause: nil
                ),
            ], catchClauses: []).javaScript(with: indentLevel)
        }
    }
}

extension GuardStatement {
    public func javaScript(with indentLevel: Int) -> String {
        switch condition {
        case let .boolean(expression):
            return IfStatement(
                condition: .boolean(PrefixUnaryOperation(operatorSymbol: "!", operand: ParenthesizedExpression(expression: expression))),
                statements: statements,
                elseClause: nil
            ).javaScript(with: indentLevel)
        case let .optionalBinding(_, name, expression):
            if let expression = expression as? IdentifierExpression, expression.identifier == name {
                return IfStatement(
                    condition: .boolean(BinaryOperation(
                        leftOperand: IdentifierExpression(identifier: name),
                        operatorSymbol: "==",
                        rightOperand: NilLiteral()
                    )),
                    statements: statements,
                    elseClause: nil
                ).javaScript(with: indentLevel)
            }
            
            return transpileStatements(statements: [
                VariableDeclaration(isStatic: false, name: name, type: nil, expression: nil),
                IfStatement(
                    condition: .boolean(BinaryOperation(
                        leftOperand: ParenthesizedExpression(expression: BinaryOperation(
                            leftOperand: IdentifierExpression(identifier: name),
                            operatorSymbol: "=",
                            rightOperand: expression
                        )),
                        operatorSymbol: "==",
                        rightOperand: NilLiteral()
                    )),
                    statements: statements,
                    elseClause: nil
                ),
            ], indentLevel: indentLevel)
        }
        
    }
}

extension LabeledStatement {
    public func javaScript(with indentLevel: Int) -> String {
        let indentDepth = indent(of: indentLevel).characters.count
        let characters: String.CharacterView = statement.javaScript(with: indentLevel).characters
        let statementWithoutIndent = String(characters.dropFirst(indentDepth))
        return "\(indent(of: indentLevel))\(labelName): \(statementWithoutIndent)"
    }
}

extension BreakStatement {
    public func javaScript(with indentLevel: Int) -> String {
        if let labelName = labelName {
            return "\(indent(of: indentLevel))break \(labelName);\n"
        } else {
            return "\(indent(of: indentLevel))break;\n"
        }
    }
}

extension ContinueStatement {
    public func javaScript(with indentLevel: Int) -> String {
        if let labelName = labelName {
            return "\(indent(of: indentLevel))continue \(labelName);\n"
        } else {
            return "\(indent(of: indentLevel))continue;\n"
        }
    }
}

extension FallthroughStatement {
    public func javaScript(with indentLevel: Int) -> String {
        return ""
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

extension ThrowStatement {
    public func javaScript(with indentLevel: Int) -> String {
        return "\(indent(of: indentLevel))throw \(expression.javaScript(with: indentLevel));\n"
    }
}

extension DoStatement {
    public func javaScript(with indentLevel: Int) -> String {
        // TODO: catch
        return "\(indent(of: indentLevel))\(transpileBlock(statements: statements, indentLevel: indentLevel))\n"
    }
}
