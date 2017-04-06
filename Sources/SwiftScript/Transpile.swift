import Foundation
import SwiftScriptAST
import SwiftScriptParse
import SwiftScriptTranslate

public func transpile(_ code: String) throws -> String {
    let statements: [Statement] = try parse(code) as! [Statement] // temporary implementation of the cast
    return try translate(statements, with: 0)
}
