extension IfStatement {
    public func javaScript(with indentLevel: Int) -> String {
        let jsIf = "\("    " * indentLevel)if (\(self.condition.javaScript(with: indentLevel))) \(transpileBlock(statements: statements, indentLevel: indentLevel))"
        guard let elseClause = self.elseClause else {
            return jsIf
        }
        switch elseClause {
        case let .elseIf(ifStatement):
            return "\(jsIf) else \(ifStatement.javaScript(with: indentLevel))"
        case let .else_(statements):
            return "\(jsIf) else \(transpileBlock(statements: statements, indentLevel: indentLevel))"
        }
    }
}
