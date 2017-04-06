import SwiftAST

internal struct UnimplementedError: Error {}

internal func translate(_ statements: [Statement], with indentLevel: Int) throws -> String {
    let jsStatements: [String] = try statements.map { statement in
        try statement.accept(JavaScriptTranslator(indentLevel: indentLevel))
    }
    return jsStatements.joined()
}

internal func translateBlock(wrapping statements: [Statement], with indentLevel: Int) throws -> String {
    return "{\n\(try translate(statements, with: indentLevel + 1))\(indent(of: indentLevel))}"
}

internal func indent(of level: Int) -> String {
    return "    " * level
}

internal struct JavaScriptTranslator: StatementVisitor, ExpressionVisitor, DeclarationVisitor {
    typealias StatementResult = String
    typealias ExpressionResult = String
    typealias DeclarationResult = String
    
    let indentLevel: Int
}

