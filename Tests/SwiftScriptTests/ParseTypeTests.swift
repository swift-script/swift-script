import XCTest
@testable import SwiftScript

class ParseTypeTests: XCTestCase {
    func testTypeIdentifier() {
        XCTAssertTrue(parseSuccess(
            type, "Foo"))
        
    }
    func testTypeArray() {
        ParseEqual(
            type,
            "[Foo]",
            ArrayType(type: TypeIdentifier­(names: ["Foo"]))
        )
        ParseEqual(
            type,
            "[ Foo ]",
            ArrayType(type: TypeIdentifier­(names: ["Foo"]))
        )
    }
    func testTypeDictionary() {
        XCTAssertTrue(parseSuccess(
            type, "[Foo: Bar]"))
        XCTAssertTrue(parseSuccess(
            type, "[Foo :Bar]"))
        XCTAssertTrue(parseSuccess(
            type, "[Foo:Bar]"))
        XCTAssertTrue(parseSuccess(
            type, "[Foo : Bar]"))
    }
    func testTypeTuple() {
        XCTAssertTrue(parseSuccess(
            type, "(A)"))
        XCTAssertTrue(parseSuccess(
            type, "(a: A, B)"))
        XCTAssertTrue(parseSuccess(
            type, "(A, b: B)"))
        XCTAssertTrue(parseSuccess(
            type, "(a:A,b:B)"))
    }
    func testTypeSuffix() {
        XCTAssertTrue(parseSuccess(
            type, "(x: Int, y: Int)?"))
        XCTAssertTrue(parseSuccess(
            type, "[Foo: [Bar???]]?!"))
    }
    func testTypeCompsition() {
        XCTAssertTrue(parseSuccess(
            type, "Foo & Bar"))
        XCTAssertTrue(parseSuccess(
            type, "(Foo) & Bar"))
    }
    func testTypeFunction() {
        XCTAssertTrue(parseSuccess(
            type, "(A) -> B"))
        XCTAssertTrue(parseSuccess(
            type, "(A, [B: C]) -> B"))
        XCTAssertTrue(parseSuccess(
            type, "(A, [B: C]) -> ([A], B) -> C & D"))
        XCTAssertFalse(parseSuccess(
            type, "(a: A) -> B"))
    }
}
