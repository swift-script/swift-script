extension IfStatement {
    public func javaScript(with indentLevel: Int) -> String {
        return "    " * indentLevel + "if " + self.condition.javaScript(with: indentLevel) + "{\n" + transpileStatements(statements: statements, indentLevel: indentLevel + 1) + "\n}"
    }
}

extension ReturnStatement {
    public func javaScript(with indentLevel: Int) -> String {
        let spaces = String(repeating: "    ", count: indentLevel)
        if let expression = expression {
            return "\(spaces)return \(expression.javaScript(with: indentLevel + 1));"
        }
        else {
            return "\(spaces)return;"
        }
    }
}
