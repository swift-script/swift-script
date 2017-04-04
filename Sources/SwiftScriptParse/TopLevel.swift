import SwiftScriptAST
import Runes
import TryParsec
import Result

let topLevel: SwiftParser<[Statement]> = stmtBraceItems <* OWS <* endOfInput()

public func parseTopLevel(_ src: String) throws -> [Statement] {
    let result = parseOnly(topLevel, src.unicodeScalars)
    switch result {
    case .success(let stmts): return stmts
    case .failure(let err): throw err
    }
}
