import SwiftAST

extension JavaScriptTranslator {
    func visit(_ n: ArrayLiteral) throws -> String {
        let values: String = try n.value.map { try $0.accept(self) }.joined(separator: ", ")
        return "[\(values)]"
    }
    
    func visit(_ n: SwiftAST.DictionaryLiteral) throws -> String {
        let keyValues: String = try n.value.map {
            "\(indent(of: indentLevel + 1))\(try $0.0.accept(self.indented)): \(try $0.1.accept(self.indented))"
        }.joined(separator: ",\n")
        
        return "{\n\(keyValues)\n\(indent(of: indentLevel))}"
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
