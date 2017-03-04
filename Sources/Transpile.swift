import Foundation

public func transpile(code: String) throws -> String {
    let statements: [Statement] = try parseTopLevel(code)
    let jsStatements: [String] = statements.map { $0.javaScript(with: 0) }
    return jsStatements.joined(separator: "\n")
}
