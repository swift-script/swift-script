import XCTest
@testable import SwiftScript

class LiteralsTests: XCTestCase {
    func testArrayLiteral() {
        XCTAssertEqual(ArrayLiteral(value: [
            IntegerLiteral(value: 2),
            IntegerLiteral(value: 3),
            IntegerLiteral(value: 5),
        ]).javaScript(with: 0), "[2, 3, 5]")
    }
    
    func testDictionaryLiteral() {
        XCTAssertEqual(SwiftScript.DictionaryLiteral(value: [
            (StringLiteral(value: "foo"), IntegerLiteral(value: 2)),
            (StringLiteral(value: "bar"), IntegerLiteral(value: 3)),
            (StringLiteral(value: "baz"), IntegerLiteral(value: 5)),
        ]).javaScript(with: 0), "{\n    \"foo\": 2,\n    \"bar\": 3,\n    \"baz\": 5\n}")
        
        XCTAssertEqual(SwiftScript.DictionaryLiteral(value: [
            (StringLiteral(value: "foo"), IntegerLiteral(value: 2)),
            (StringLiteral(value: "bar"), IntegerLiteral(value: 3)),
            (StringLiteral(value: "baz"), IntegerLiteral(value: 5)),
            ]).javaScript(with: 1), "{\n        \"foo\": 2,\n        \"bar\": 3,\n        \"baz\": 5\n    }")
    }
    
    func testIntegerLiteral() {
        XCTAssertEqual(IntegerLiteral(value: 42).javaScript(with: 0), "42")
    }

    func testFloatingPointLiteral() {
        XCTAssertEqual(FloatingPointLiteral(value: 12.5).javaScript(with: 0), "12.5")
    }
    
    func testStringLiteral() {
        XCTAssertEqual(StringLiteral(value: "xyz").javaScript(with: 0), "\"xyz\"")
    }
    
    func testBooleanLiteral() {
        XCTAssertEqual(BooleanLiteral(value: true).javaScript(with: 0), "true")
        XCTAssertEqual(BooleanLiteral(value: false).javaScript(with: 0), "false")
    }
    
    func testNilLiteral() {
        XCTAssertEqual(NilLiteral().javaScript(with: 0), "null")
    }
}
