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
        let jsArguments: [String] = arguments.map { _, name, _, initialValue in
            if let initialValue = initialValue {
                return "name = \(initialValue)"
            } else {
                return name
            }
        }
        
        // `body!` because `FunctionDeclaration` without `body` is for `protocol`s and thier `javaScript` is never called
        return "\(indent(of: indentLevel))function \(name)(\(jsArguments.joined(separator: ", "))) \(transpileBlock(statements: body!, indentLevel: indentLevel))\n"
    }
}

extension ClassDeclaration­ {
    public func javaScript(with indentLevel: Int) -> String {
        let decls = members.map { $0.javaScript(with: indentLevel + 1) }.joined(separator: "\n")
        let spaces = String(repeating: "    ", count: indentLevel)
        let newLine = decls.isEmpty ? "" : "\n"
        // TODO: should implement extends
        return "\(spaces)class \(name) {\n\(decls)\(newLine)\(spaces)}"
    }
}
