import XCTest
import Runes
import TryParsec
@testable import SwiftScript

func parseIt<Out>(_ parser: SwiftParser<Out>, _ str: String) throws -> Out {
    let result = parseOnly(parser <* endOfInput(), str.unicodeScalars)
    switch result {
    case .success(let out): return out
    case .failure(let err): throw err
    }
}

func parseSuccess<Out>(_ parser: SwiftParser<Out>, _ str: String) -> Bool {
    do {
        _ = try parseIt(parser, str)
        return true
    } catch {
        return false
    }
}
