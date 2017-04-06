import XCTest
import Runes
import TryParsec
@testable import SwiftParse

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

func ParseAssertEqual<Out, Expect: Equatable>(_ parser: SwiftParser<Out>, _ src: String, _ expect: Expect, file: StaticString = #file, line: UInt = #line) {
    do {
        let res = try parseIt(parser, src)
        guard let result = res as? Expect else {
            return XCTFail(
                "Parse resulted different type \(type(of: res as Any)) to \(type(of: expect))",
                file: file, line: line
            )
        }
        XCTAssertEqual(result, expect, file: file, line: line)
    } catch let e {
        XCTFail(
            "Parse failed: \(e)",
            file: file, line: line
        )
    }
}
