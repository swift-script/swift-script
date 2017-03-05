import Foundation

public func transpile(code: String) throws -> String {
    let statements: [Statement] = try parseTopLevel(code)
    return transpileStatements(statements: statements, indentLevel: 0)
}

public func transpileStatements(statements: [Statement], indentLevel: Int) -> String {
    let jsStatements: [String] = statements.map { statement in
        if statement is Expression {
            return "\(indent(of: indentLevel))\(statement.javaScript(with: indentLevel));"
        }
        return statement.javaScript(with: indentLevel)
    }
    return jsStatements.joined(separator: "\n")
}

public func transpileBlock(statements: [Statement], indentLevel: Int) -> String {
    return "{\n\(transpileStatements(statements: statements, indentLevel: indentLevel + 1))\n\(indent(of: indentLevel))}"
}

public func indent(of level: Int) -> String {
    return "    " * level
}
