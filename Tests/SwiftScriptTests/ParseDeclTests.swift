import XCTest
@testable import SwiftScript

class ParseDeclTests: XCTestCase {
    func testDeclFunction() {
        XCTAssertTrue(parseSuccess(
            declFunction,
            "func foo(x: A = 1, x y: B) throws -> C {\n"
                + "  return foo\n"
                + "}"))
        XCTAssertTrue(parseSuccess(
            declFunction,
            "func foo(x:A=1,x y:B)throws->C{return foo}"))
    }
    
    func testDeclConstant() {
        XCTAssertTrue(parseSuccess(
            declConstant, "let a = 1"))
        XCTAssertTrue(parseSuccess(
            declConstant, "let a=1"))
        XCTAssertTrue(parseSuccess(
            declConstant, "let a : Int = 1"))
    }
    
    func testDeclVariable() {
        XCTAssertTrue(parseSuccess(
            declVariable, "var a = 1"))
        XCTAssertTrue(parseSuccess(
            declVariable, "var a=1"))
        XCTAssertTrue(parseSuccess(
            declVariable, "var a : Int = 1"))
    }
}
