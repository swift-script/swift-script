import Foundation
import SwiftScriptAST
import SwiftScriptParse
import SwiftScriptTranslate

public func transpile(code: String) throws -> String {
    let statements: [Statement] = try parse(code)
    return try translateStatements(statements: statements, indentLevel: 0)
}
