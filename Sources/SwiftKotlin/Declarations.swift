import SwiftAST

extension KotlinTranslator {
    func visit(_: ImportDeclaration) throws -> String {
        throw UnimplementedError()
    }
    
    func visit(_ n: ConstantDeclaration) throws -> String {
        guard !n.isStatic else {
            // static properties must be translated in type layers
            return ""
        }

        var type = try n.type?.accept(self) ?? ""
        if !type.isEmpty {
            type = ": " + type
        }

        if let expression = n.expression {
            return "\(indent(of: indentLevel))val \(n.name)\(type) = \(try expression.accept(self))\n"
        } else {
            return "\(indent(of: indentLevel))val \(n.name)\(type)\n"
        }
    }
    
    func visit(_ n: VariableDeclaration) throws -> String {
        guard !n.isStatic else {
            // static properties must be translated in type layers
            return ""
        }

        var type = try n.type?.accept(self) ?? ""
        if !type.isEmpty {
            type = ": " + type
        }

        if let expression = n.expression {
            return "\(indent(of: indentLevel))var \(n.name)\(type) = \(try expression.accept(self))\n"
        } else {
            return "\(indent(of: indentLevel))var \(n.name)\(type)\n"
        }
    }

    func visit(_ n: VariableDeclaration.GetSet) throws -> String {
        return ""
    }
    
    func visit(_: TypeAliasDeclaration) throws -> String {
        throw UnimplementedError()
    }

    func visit(_ n: FunctionDeclaration) throws -> String {
        let jsArguments: [String] = try n.arguments.map { param in
            if let initialValue = param.defaultArgument {
                return "\(param.localParameterName): \(try param.type.accept(self)) = \(try initialValue.accept(self))"
            } else {
                return "\(param.localParameterName): \(try param.type.accept(self))"
            }
        }

        var retType = try n.result?.accept(self) ?? ""
        if !retType.isEmpty {
            retType = ": \(retType)"
        }
        
        // `body!` because `FunctionDeclaration` without `body` is for `protocol`s and thier `kotlin` is never called
        // TODO: Change to `companion object`.
        return "\(indent(of: indentLevel))\(n.isStatic ? "static " : "")fun \(n.name)(\(jsArguments.joined(separator: ", ")))\(retType) \(try translateBlock(wrapping: n.body!, with: indentLevel))\n"
    }
    
    func visit(_: EnumDeclaration) throws -> String {
        throw UnimplementedError()
    }

    /// Convert to Kotlin's `data class` if data only.
    /// Otherwise, convert to `class`.
    func visit(_ n: StructDeclaration) throws -> String {
        let properties = n.members.filter {
            switch $0 {
            case is VariableDeclaration:
                return true
            case is ConstantDeclaration:
                return true
            default:
                return false
            }
        }

        /// Fallback to `ClassDeclaration` if there are non-data declarations.
        if properties.count != n.members.count {
            let classDeclaration = ClassDeclaration(name: n.name, superTypes: n.superTypes, members: n.members)
            return try visit(classDeclaration)
        }

        let propertiesString = try properties
            .map { try $0.accept(self).trimmingCharacters(in: .whitespacesAndNewlines) }
            .joined(separator: ", ")

        let str = "\(indent(of: indentLevel))data class \(n.name)(\(propertiesString))\n"
        return str
    }
    
    func visit(_ n: ClassDeclaration) throws -> String {
        var superTypes = try n.superTypes
            .map { try $0.accept(self.indented) }
            .joined(separator: ", ")
        if !superTypes.isEmpty {
            superTypes = ": \(superTypes)"
        }

        let members = try n.members
            .map { try $0.accept(self.indented) }
            .joined()

        return "\(indent(of: indentLevel))class \(n.name)\(superTypes) {\n\(members)\(indent(of: indentLevel))}\n"
    }
    
    func visit(_ n: ProtocolDeclaration) throws -> String {
        var superTypes = try n.superTypes
            .map { try $0.accept(self.indented) }
            .joined(separator: ", ")
        if !superTypes.isEmpty {
            superTypes = ": \(superTypes)"
        }

        let members = try n.members
            .map { try $0.accept(self.indented) }
            .joined()

        return "\(indent(of: indentLevel))interface \(n.name)\(superTypes) {\n\(members)\(indent(of: indentLevel))}\n"
    }

    func visit(_ n: InitializerDeclaration) throws -> String {
        // Move `super.init()` next to Kotlin constructor's declaration.
        var superInit = ""

        guard var body = n.body else {
            throw UnimplementedError()
        }

        for (i, stmt) in n.body!.enumerated() {
            if let stmt = stmt as? ExpressionStatement,
                let funcCallExpr = stmt.expression as? FunctionCallExpression,
                let initExpr = funcCallExpr.expression as? InitializerExpression,
                initExpr.receiverExpression is SuperclassExpression {

                superInit = ": \(try funcCallExpr.accept(self))"
                body.remove(at: i)
                break
            }
        }

        let arguments: [String] = try n.arguments.map { param in
            if let initialValue = param.defaultArgument {
                return "\(param.localParameterName): \(try param.type.accept(self)) = \(initialValue)"
            } else {
                return "\(param.localParameterName): \(try param.type.accept(self))"
            }
        }

        return "\(indent(of: indentLevel))constructor(\(arguments.joined(separator: ", ")))\(superInit) \(try translateBlock(wrapping: body, with: indentLevel))\n"
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
