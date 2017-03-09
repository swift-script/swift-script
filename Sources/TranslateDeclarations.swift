extension ConstantDeclaration {
    public func javaScript(with indentLevel: Int) -> String {
        guard !isStatic else {
            // static properties must be translated in type layers
            return ""
        }
        
        if let expression = expression {
            return "\(indent(of: indentLevel))const \(name) = \(expression.javaScript(with: indentLevel));\n"
        } else {
            return "\(indent(of: indentLevel))const \(name);\n"
        }
    }
}

extension VariableDeclaration {
    public func javaScript(with indentLevel: Int) -> String {
        guard !isStatic else {
            // static properties must be translated in type layers
            return ""
        }
        
        if let expression = expression {
            return "\(indent(of: indentLevel))let \(name) = \(expression.javaScript(with: indentLevel));\n"
        } else {
            return "\(indent(of: indentLevel))let \(name);\n"
        }
    }
}

extension FunctionDeclaration {
    public func javaScript(with indentLevel: Int) -> String {
        let jsArguments: [String] = arguments.map { param in
            if let initialValue = param.defaultArgument {
                return "\(param.localParameterName) = \(initialValue)"
            } else {
                return param.localParameterName
            }
        }
        
        // `body!` because `FunctionDeclaration` without `body` is for `protocol`s and thier `javaScript` is never called
        return "\(indent(of: indentLevel))\(isStatic ? "static " : "")function \(name)(\(jsArguments.joined(separator: ", "))) \(transpileBlock(statements: body!, indentLevel: indentLevel))\n"
    }
}

extension ClassDeclaration­ {
    public func javaScript(with indentLevel: Int) -> String {
        let propertiesWithInitialValues = members.filter {
            switch $0 {
            case let variable as VariableDeclaration:
                return variable.expression != nil
            case let constant as ConstantDeclaration:
                return constant.expression != nil
            default:
                return false
            }
        }
        let membersExcludingProperties = members.filter { !($0 is VariableDeclaration || $0 is ConstantDeclaration) }
        let adjustedMembers = membersExcludingProperties.map { member -> Declaration in
            guard var initializer = member as? InitializerDeclaration­ else {
                return member
            }
            
            for property in propertiesWithInitialValues {
                let name: String
                let initialValue: Expression
                switch property {
                case let variable as VariableDeclaration:
                    name = variable.name
                    initialValue = variable.expression!
                case let constant as ConstantDeclaration:
                    name = constant.name
                    initialValue = constant.expression!
                default:
                    fatalError("Never reaches here.")
                }
                
                initializer.body!.append(BinaryOperation(
                    leftOperand: ExplicitMemberExpression(expression: SelfExpression(), member: name),
                    operatorSymbol: "=",
                    rightOperand: initialValue
                ))
            }
            
            return initializer
        }
        
        let jsMembers: [String] = adjustedMembers.map { member in
            let js = member.javaScript(with: indentLevel + 1)
            guard member is FunctionDeclaration else {
                if member is Expression {
                    return "\(indent(of: indentLevel + 1))\(js);\n"
                }
                return js
            }
            
            let characters = js.characters.dropFirst(indent(of: indentLevel + 1).characters.count + 9)
            return "\(indent(of: indentLevel + 1))\(String(characters))"
        }
        
        return "\(indent(of: indentLevel))class \(name) {\n\(jsMembers.joined())\(indent(of: indentLevel))}\n"
    }
}

extension InitializerDeclaration­ {
    public func javaScript(with indentLevel: Int) -> String {
        let jsArguments: [String] = arguments.map { param in
            if let initialValue = param.defaultArgument {
                return "\(param.localParameterName) = \(initialValue)"
            } else {
                return param.localParameterName
            }
        }
        // `body!` because `FunctionDeclaration` without `body` is for `protocol`s and thier `javaScript` is never called
        return "\(indent(of: indentLevel))constructor(\(jsArguments.joined(separator: ", "))) \(transpileBlock(statements: body!, indentLevel: indentLevel))\n"
    }
}
