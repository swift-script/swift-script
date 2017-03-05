import XCTest
@testable import SwiftScript


class ParseDeclTests: XCTestCase {
    func testFunction() {
        XCTAssertTrue(parseSuccess(
            declFunction,
            "func foo(x: A = 1, x y: B) throws -> C {\n"
                + "  return foo\n"
                + "}"))
        XCTAssertTrue(parseSuccess(
            declFunction,
            "func foo(x:A=1,x y:B)throws->C{return foo}"))
    }
    
}
