extension JavaScriptTranslator {
    func visit(_ n: ArrayLiteral) throws -> String {
        let values: String = n.value.map { $0.javaScript(with: indentLevel + 1) }.joined(separator: ", ")
        return "[\(values)]"
    }
    
    func visit(_ n: DictionaryLiteral) throws -> String {
        let keyValues: String = n.value.map {
            "\("    " * (indentLevel + 1))\($0.0.javaScript(with: indentLevel + 1)): \($0.1.javaScript(with: indentLevel + 1))"
            }.joined(separator: ",\n")
        
        
        return "{\n\(keyValues)\n\("    " * indentLevel)}"
    }
    
    func visit(_ n: IntegerLiteral) throws -> String {
        return  "\(n.value)"
    }
    
    func visit(_ n: FloatingPointLiteral) throws -> String {
        return  "\(n.value)"
    }
    
    func visit(_ n: StringLiteral) throws -> String {
        // TODO: escaping special characters
        return  "\"\(n.value)\""
    }
    
    func visit(_ n: BooleanLiteral) throws -> String {
        return  n.value ? "true" : "false"
    }
    
    func visit(_ n: NilLiteral) throws -> String {
        return  "null"
    }
}
