import SwiftAST
import Runes
import TryParsec
import Result

let topLevel: SwiftParser<[Statement]> = stmtBraceItems <* OWS <* endOfInput()

public func parse(_ sourceCode: String) throws -> [Statement] {
    let result = parseOnly(topLevel, sourceCode.unicodeScalars)
    switch result {
    case .success(let stmts): return stmts
    case .failure(let err): throw err
    }
}
