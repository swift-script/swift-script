import XCTest
@testable import SwiftScript

class SwiftScriptTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(SwiftScript().text, "Hello, World!")
    }


    static var allTests : [(String, (SwiftScriptTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
