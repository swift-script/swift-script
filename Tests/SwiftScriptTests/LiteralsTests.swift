import XCTest
@testable import SwiftScript

class LiteralsTests: XCTestCase {
    func testArrayLiteral() {
        XCTAssertEqual(ArrayLiteral(value: [
            IntegerLiteral(value: 2),
            IntegerLiteral(value: 3),
            IntegerLiteral(value: 5),
        ]).javaScript, "[2, 3, 5]")
    }
    
    func testDictionaryLiteral() {
        XCTAssertEqual(SwiftScript.DictionaryLiteral(value: [
            (StringLiteral(value: "foo"), IntegerLiteral(value: 2)),
            (StringLiteral(value: "bar"), IntegerLiteral(value: 3)),
            (StringLiteral(value: "baz"), IntegerLiteral(value: 5)),
        ]).javaScript, "{\"foo\": 2, \"bar\": 3, \"baz\": 5}")
    }
    
    func testIntegerLiteral() {
        XCTAssertEqual(IntegerLiteral(value: 42).javaScript, "42")
    }

    func testFloatingPointLiteral() {
        XCTAssertEqual(FloatingPointLiteral(value: 12.5).javaScript, "12.5")
    }
    
    func testStringLiteral() {
        XCTAssertEqual(StringLiteral(value: "xyz").javaScript, "\"xyz\"")
    }
    
    func testBooleanLiteral() {
        XCTAssertEqual(BooleanLiteral(value: true).javaScript, "true")
        XCTAssertEqual(BooleanLiteral(value: false).javaScript, "false")
    }
    
    func testNilLiteral() {
        XCTAssertEqual(NilLiteral().javaScript, "nil")
    }
}
