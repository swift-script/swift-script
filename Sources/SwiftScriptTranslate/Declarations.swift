import SwiftScriptAST

extension JavaScriptTranslator {
    func visit(_: ImportDeclaration) throws -> String {
        throw UnimplementedError()
    }
    
    func visit(_ n: ConstantDeclaration) throws -> String {
        guard !n.isStatic else {
            // static properties must be translated in type layers
            return ""
        }
        
        if let expression = n.expression {
            return "\(indent(of: indentLevel))const \(n.name) = \(try expression.accept(JavaScriptTranslator(indentLevel: indentLevel)));\n"
        } else {
            return "\(indent(of: indentLevel))const \(n.name);\n"
        }
    }
    
    func visit(_ n: VariableDeclaration) throws -> String {
        guard !n.isStatic else {
            // static properties must be translated in type layers
            return ""
        }
        
        if let expression = n.expression {
            return "\(indent(of: indentLevel))let \(n.name) = \(try expression.accept(JavaScriptTranslator(indentLevel: indentLevel)));\n"
        } else {
            return "\(indent(of: indentLevel))let \(n.name);\n"
        }
    }
    
    func visit(_: TypeAliasDeclaration) throws -> String {
        throw UnimplementedError()
    }

    
    func visit(_ n: FunctionDeclaration) throws -> String {
        let jsArguments: [String] = n.arguments.map { param in
            if let initialValue = param.defaultArgument {
                return "\(param.localParameterName) = \(initialValue)"
            } else {
                return param.localParameterName
            }
        }
        
        // `body!` because `FunctionDeclaration` without `body` is for `protocol`s and thier `javaScript` is never called
        return "\(indent(of: indentLevel))\(n.isStatic ? "static " : "")function \(n.name)(\(jsArguments.joined(separator: ", "))) \(try translateBlock(wrapping: n.body!, with: indentLevel))\n"
    }
    
    func visit(_: EnumDeclaration) throws -> String {
        throw UnimplementedError()
    }
    func visit(_: StructDeclaration) throws -> String {
        throw UnimplementedError()
    }
    
    func visit(_ n: ClassDeclaration) throws -> String {
        let propertiesWithInitialValues = n.members.filter {
            switch $0 {
            case let variable as VariableDeclaration:
                return variable.expression != nil
            case let constant as ConstantDeclaration:
                return constant.expression != nil
            default:
                return false
            }
        }
        let membersExcludingProperties = n.members.filter { !($0 is VariableDeclaration || $0 is ConstantDeclaration) }
        let adjustedMembers = membersExcludingProperties.map { member -> Declaration in
            guard var initializer = member as? InitializerDeclaration else {
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
                
                initializer.body!.append(ExpressionStatement(BinaryOperation(
                    leftOperand: ExplicitMemberExpression(expression: SelfExpression(), member: name),
                    operatorSymbol: "=",
                    rightOperand: initialValue
                )))
            }
            
            return initializer
        }
        
        let jsMembers: [String] = try adjustedMembers.map { member in
            let js = try member.accept(JavaScriptTranslator(indentLevel: indentLevel + 1))
            guard member is FunctionDeclaration else {
                return js
            }
            
            let characters = js.characters.dropFirst(indent(of: indentLevel + 1).characters.count + 9)
            return "\(indent(of: indentLevel + 1))\(String(characters))"
        }
        
        return "\(indent(of: indentLevel))class \(n.name) {\n\(jsMembers.joined())\(indent(of: indentLevel))}\n"
    }
    
    func visit(_: ProtocolDeclaration) throws -> String {
        throw UnimplementedError()
    }

    func visit(_ n: InitializerDeclaration) throws -> String {
        let jsArguments: [String] = n.arguments.map { param in
            if let initialValue = param.defaultArgument {
                return "\(param.localParameterName) = \(initialValue)"
            } else {
                return param.localParameterName
            }
        }
        // `body!` because `FunctionDeclaration` without `body` is for `protocol`s and thier `javaScript` is never called
        return "\(indent(of: indentLevel))constructor(\(jsArguments.joined(separator: ", "))) \(try translateBlock(wrapping: n.body!, with: indentLevel))\n"
    }

    func visit(_: DeinitializerDeclaration) throws -> String {
        throw UnimplementedError()
    }
    
    func visit(_: ExtensionDeclaration) throws -> String {
        throw UnimplementedError()
    }
    
    func visit(_: SubscriptDeclaration) throws -> String {
        throw UnimplementedError()
    }
    
    func visit(_: OperatorDeclaration) throws -> String {
        throw UnimplementedError()
    }
    
    func visit(_: PrecedenceGroupDeclaration) throws -> String {
        throw UnimplementedError()
    }
}
