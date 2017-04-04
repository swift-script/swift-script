import SwiftScriptAST

internal struct UnimplementedError: Error {}

public func transpileStatements(statements: [Statement], indentLevel: Int) throws -> String {
    let jsStatements: [String] = try statements.map { statement in
        try statement.accept(JavaScriptTranslator(indentLevel: indentLevel))
    }
    return jsStatements.joined()
}

public func transpileBlock(statements: [Statement], indentLevel: Int) throws -> String {
    return "{\n\(try transpileStatements(statements: statements, indentLevel: indentLevel + 1))\(indent(of: indentLevel))}"
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

