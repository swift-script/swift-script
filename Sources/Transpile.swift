import Foundation

public func transpile(code: String) throws -> String {
    let statements: [Statement] = try parseTopLevel(code)
    return transpileStatements(statements: statements, indentLevel: 0)
}

public func transpileStatements(statements: [Statement], indentLevel: Int) -> String {
    let jsStatements: [String] = statements.map { statement in
        if statement is Expression {
            return "\("    " * indentLevel)\(statement.javaScript(with: indentLevel));"
        }
        return statement.javaScript(with: indentLevel)
    }
    return jsStatements.joined(separator: "\n")
}
