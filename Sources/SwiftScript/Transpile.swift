import Foundation
import SwiftScriptAST
import SwiftScriptParse
import SwiftScriptTranslate

public func transpile(code: String) throws -> String {
    let statements: [Statement] = try parse(code) as! [Statement] // temporary implementation of the cast
    return try translateStatements(statements: statements, indentLevel: 0)
}
