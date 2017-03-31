import Foundation

public func transpile(code: String) throws -> String {
    let statements: [Statement] = try parseTopLevel(code)
    return transpileStatements(statements: statements, indentLevel: 0)
}

public func transpileStatements(statements: [Statement], indentLevel: Int) -> String {
    let jsStatements: [String] = statements.map { statement in
        statement.javaScript(with: indentLevel)
    }
    return jsStatements.joined()
}

public func transpileBlock(statements: [Statement], indentLevel: Int) -> String {
    return "{\n\(transpileStatements(statements: statements, indentLevel: indentLevel + 1))\(indent(of: indentLevel))}"
}

public func indent(of level: Int) -> String {
    return "    " * level
}

internal struct JavaScriptTranslator: StatementVisitor, ExpressionVisitor, DeclarationVisitor {
    typealias StatementResult = String
    typealias ExpressionResult = String
    typealias DeclarationResult = String
    
    let indentLevel: Int
}

internal struct UnimplementedError: Error {}
