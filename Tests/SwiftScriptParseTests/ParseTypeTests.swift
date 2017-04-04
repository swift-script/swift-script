import XCTest
import SwiftScriptAST
@testable import SwiftScriptParse

class ParseTypeTests: XCTestCase {
    func testTypeIdentifier() {
        XCTAssertTrue(parseSuccess(
            type, "Foo"))
        
    }
    func testTypeArray() {
        ParseAssertEqual(
            type,
            "[Foo]",
            ArrayType(type: TypeIdentifier(names: ["Foo"]))
        )
        ParseAssertEqual(
            type,
            "[ Foo ]",
            ArrayType(type: TypeIdentifier(names: ["Foo"]))
        )
    }
    func testTypeDictionary() {
        ParseAssertEqual(
            type,
            "[Foo: Bar]",
            DictionaryType(
                keyType: TypeIdentifier(names: ["Foo"]),
                valueType: TypeIdentifier(names: ["Bar"])
            )
        )
        ParseAssertEqual(
            type,
            "[Foo :Bar]",
            DictionaryType(
                keyType: TypeIdentifier(names: ["Foo"]),
                valueType: TypeIdentifier(names: ["Bar"])
            )
        )
        ParseAssertEqual(
            type,
            "[Foo:Bar]",
            DictionaryType(
                keyType: TypeIdentifier(names: ["Foo"]),
                valueType: TypeIdentifier(names: ["Bar"])
            )
        )
        ParseAssertEqual(
            type,
            "[Foo : Bar]",
            DictionaryType(
                keyType: TypeIdentifier(names: ["Foo"]),
                valueType: TypeIdentifier(names: ["Bar"])
            )
        )
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
