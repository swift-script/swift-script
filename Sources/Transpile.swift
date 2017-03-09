import Foundation

public func transpile(code: String) throws -> String {
    let statements: [Statement] = try parseTopLevel(code)
    return transpileStatements(statements: statements, indentLevel: 0)
}

public func transpileStatements(statements: [Statement], indentLevel: Int) -> String {
    let jsStatements: [String] = statements.map { statement in
        if let expression = statement as? Expression {
            return transpileExpressionStatement(expression: expression, indentLevel: indentLevel)
        }
        return statement.javaScript(with: indentLevel)
    }
    return jsStatements.joined()
}

public func transpileBlock(statements: [Statement], indentLevel: Int) -> String {
    return "{\n\(transpileStatements(statements: statements, indentLevel: indentLevel + 1))\(indent(of: indentLevel))}"
}

public func transpileExpressionStatement(expression: Expression, indentLevel: Int) -> String {
    return "\(indent(of: indentLevel))\(expression.javaScript(with: indentLevel));\n"
}

public func indent(of level: Int) -> String {
    return "    " * level
}
