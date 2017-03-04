extension IfStatement {
    public func javaScript(with indentLevel: Int) -> String {
        return "    " * indentLevel + "if (" + self.condition.javaScript(with: indentLevel) + ") {\n" + transpileStatements(statements: statements, indentLevel: indentLevel + 1) + "\n}"
    }
}
