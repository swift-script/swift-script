import XCTest
@testable import SwiftScript

class SwiftScriptTests: XCTestCase {
    func testExample() {
        print(try! transpile("3 + 5"))
    }

    static var allTests : [(String, (SwiftScriptTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
