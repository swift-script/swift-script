import XCTest
@testable import SwiftScript

class ParsePrimitiveTests: XCTestCase {
    func testPunctuators() {
        XCTAssertEqual(try parseIt(l_paren, "("), "(")
        XCTAssertEqual(try parseIt(r_paren, ")"), ")")
        XCTAssertEqual(try parseIt(l_brace, "{"), "{")
        XCTAssertEqual(try parseIt(r_brace, "}"), "}")
        XCTAssertEqual(try parseIt(l_square, "["), "[")
        XCTAssertEqual(try parseIt(r_square, "]"), "]")
        XCTAssertEqual(try parseIt(l_angle, "<"), "<")
        XCTAssertEqual(try parseIt(r_angle, ">"), ">")
    }
    
    func testStringLiterals() {
        XCTAssertEqual(try parseIt(stringLiteral, "\"\""), "")
        XCTAssertEqual(try parseIt(stringLiteral, "\"foo\""), "foo")
        XCTAssertEqual(try parseIt(stringLiteral, "\"f\\\"o\""), "f\"o")
        XCTAssertEqual(try parseIt(stringLiteral, "\"\\n\""), "\n")
    }
    
    func testIntegerLiterals() {
        XCTAssertEqual(try parseIt(integerLiteral, "1234"), 1234)
        XCTAssertEqual(try parseIt(integerLiteral, "012"), 12)
        // 0x12
        // 100_00
        // 0xFF
        // 0xff
    }
    func testFloatLiterals() {
        XCTAssertEqual(try parseIt(floatLiteral, "1.234"), 1.234)
        XCTAssertEqual(try parseIt(floatLiteral, "0.1"), 0.1)
    }
    func testKeywords() {
        XCTAssertEqual(try parseIt(kw_is, "is"), "is")
        XCTAssertThrowsError(try parseIt(kw_is, "isa"))
    }
    func testIdentifiers() {
        XCTAssertEqual(try parseIt(identifier, "foo"), "foo")
        XCTAssertEqual(try parseIt(identifier, "`is`"), "is")
        XCTAssertThrowsError(try parseIt(identifier, "is"))
        XCTAssertThrowsError(try parseIt(identifier, "$f12"))
        XCTAssertThrowsError(try parseIt(identifier, "$12"))
    }
    func testKeywordOrIdentifier() {
        XCTAssertEqual(try parseIt(keywordOrIdentifier, "is"), "is")
        XCTAssertEqual(try parseIt(keywordOrIdentifier, "`is`"), "is")
        XCTAssertThrowsError(try parseIt(keywordOrIdentifier, "$0"))
        XCTAssertThrowsError(try parseIt(keywordOrIdentifier, "`$0`"))
    }
    func testDollerIdentifier() {
        XCTAssertEqual(try parseIt(dollarIdentifier, "$12"), "$12")
        XCTAssertThrowsError(try parseIt(dollarIdentifier, "`$0`"))
    }
    func testOWS() {
        XCTAssertTrue(parseSuccess(OWS, ""))
        XCTAssertTrue(parseSuccess(OWS, " "))
        XCTAssertTrue(parseSuccess(OWS, "\n"))
        XCTAssertTrue(parseSuccess(OWS, " \n "))
    }
    
    func testWS() {
        XCTAssertFalse(parseSuccess(WS, ""))
        XCTAssertTrue(parseSuccess(WS, " "))
        XCTAssertTrue(parseSuccess(WS, "\n"))
        XCTAssertTrue(parseSuccess(WS, " \n "))
    }
    
    func testOHWS() {
        XCTAssertTrue(parseSuccess(OHWS, ""))
        XCTAssertTrue(parseSuccess(OHWS, " "))
        XCTAssertFalse(parseSuccess(OHWS, "\n"))
        XCTAssertFalse(parseSuccess(OHWS, " \n "))
    }
    
    func testVS() {
        XCTAssertFalse(parseSuccess(VS, ""))
        XCTAssertFalse(parseSuccess(VS, " "))
        XCTAssertTrue(parseSuccess(VS, "\n"))
        XCTAssertTrue(parseSuccess(VS, "\r"))
        XCTAssertTrue(parseSuccess(VS, "\r\n"))
        XCTAssertTrue(parseSuccess(VS, " \n\t\n"))
    }
}
