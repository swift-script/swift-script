extension ForInStatement {
    public func javaScript(with indentLevel: Int) -> String {
        return "for (\(item) of \(collection.javaScript(with: indentLevel))) \(transpileBlock(statements: statements, indentLevel: indentLevel))\n"
    }
}

extension IfStatement {
    public func javaScript(with indentLevel: Int) -> String {
        let jsIf = "\("    " * indentLevel)if (\(self.condition.javaScript(with: indentLevel))) \(transpileBlock(statements: statements, indentLevel: indentLevel))"
        guard let elseClause = self.elseClause else {
            return "\(jsIf)\n"
        }
        switch elseClause {
        case let .elseIf(ifStatement):
            return "\(jsIf) else \(ifStatement.javaScript(with: indentLevel))"
        case let .else_(statements):
            return "\(jsIf) else \(transpileBlock(statements: statements, indentLevel: indentLevel))\n"
        }
    }
}
