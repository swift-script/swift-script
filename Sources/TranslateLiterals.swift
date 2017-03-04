extension IntegerLiteral {
    public func javaScript(with indentLevel: Int) -> String {
        return  "\(value)"
    }
}

extension StringLiteral {
    public func javaScript(with indentLevel: Int) -> String {
        // TODO: escaping special characters
        return  "\"\(value)\""
    }
}

extension DictionaryLiteral {
    public func javaScript(with indentLevel: Int) -> String {
        let keyValues: String = value.map {
            "\("    " * (indentLevel + 1))\($0.0.javaScript(with: indentLevel + 1)): \($0.1.javaScript(with: indentLevel + 1))"
        }.joined(separator: ",\n")
        
        
        return "{\n\(keyValues)\n\("    " * indentLevel)}"
    }
}
