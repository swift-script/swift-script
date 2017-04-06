import Foundation
import SwiftAST
import SwiftParse

public func transpile(_ code: String) throws -> String {
    let statements: [Statement] = try parse(code) as! [Statement] // temporary implementation of the cast
    return try translate(statements, with: 0)
}
