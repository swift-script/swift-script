import Foundation
import SwiftScriptAST
import SwiftScriptParse
import SwiftScriptTranslate

public func transpile(code: String) throws -> String {
    let statements: [Statement] = try parseTopLevel(code)
    return try transpileStatements(statements: statements, indentLevel: 0)
}
