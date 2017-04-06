import XCTest
import SwiftAST
@testable import SwiftScript

class LiteralsTests: XCTestCase {
    func testArrayLiteral() {
        XCTAssertEqual(try! ArrayLiteral(value: [
            IntegerLiteral(value: 2),
            IntegerLiteral(value: 3),
            IntegerLiteral(value: 5),
        ]).accept(JavaScriptTranslator(indentLevel: 0)), "[2, 3, 5]")
    }
    
    func testDictionaryLiteral() {
        XCTAssertEqual(try! SwiftAST.DictionaryLiteral(value: [
            (StringLiteral(value: "foo"), IntegerLiteral(value: 2)),
            (StringLiteral(value: "bar"), IntegerLiteral(value: 3)),
            (StringLiteral(value: "baz"), IntegerLiteral(value: 5)),
        ]).accept(JavaScriptTranslator(indentLevel: 0)), "{\n    \"foo\": 2,\n    \"bar\": 3,\n    \"baz\": 5\n}")
        
        XCTAssertEqual(try! SwiftAST.DictionaryLiteral(value: [
            (StringLiteral(value: "foo"), IntegerLiteral(value: 2)),
            (StringLiteral(value: "bar"), IntegerLiteral(value: 3)),
            (StringLiteral(value: "baz"), IntegerLiteral(value: 5)),
            ]).accept(JavaScriptTranslator(indentLevel: 1)), "{\n        \"foo\": 2,\n        \"bar\": 3,\n        \"baz\": 5\n    }")
    }
    
    func testIntegerLiteral() {
        XCTAssertEqual(try! IntegerLiteral(value: 42).accept(JavaScriptTranslator(indentLevel: 0)), "42")
    }

    func testFloatingPointLiteral() {
        XCTAssertEqual(try! FloatingPointLiteral(value: 12.5).accept(JavaScriptTranslator(indentLevel: 0)), "12.5")
    }
    
    func testStringLiteral() {
        XCTAssertEqual(try! StringLiteral(value: "xyz").accept(JavaScriptTranslator(indentLevel: 0)), "\"xyz\"")
    }
    
    func testBooleanLiteral() {
        XCTAssertEqual(try! BooleanLiteral(value: true).accept(JavaScriptTranslator(indentLevel: 0)), "true")
        XCTAssertEqual(try! BooleanLiteral(value: false).accept(JavaScriptTranslator(indentLevel: 0)), "false")
    }
    
    func testNilLiteral() {
        XCTAssertEqual(try! NilLiteral().accept(JavaScriptTranslator(indentLevel: 0)), "null")
    }
}
