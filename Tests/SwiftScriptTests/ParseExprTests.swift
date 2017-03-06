import XCTest
@testable import SwiftScript

class ParseExprTests: XCTestCase {
    func testExpr() {
        XCTAssertTrue(parseSuccess(
            expr, "a + try! b + try? c as C is C*12 + !X"))
        XCTAssertTrue(parseSuccess(
            expr, "[foo, x[12]]"))
    }
    
    func testExprIdentifier() {
        XCTAssertTrue(parseSuccess(
            exprIdentifier, "foo"))
        XCTAssertTrue(parseSuccess(
            exprIdentifier, "foo<A, B>"))
        XCTAssertFalse(parseSuccess(
            exprIdentifier, "self"))
    }
    
    func testExprCall() {
        XCTAssertTrue(parseSuccess(
            expr, "foo(x)"))
        XCTAssertTrue(parseSuccess(
            expr, "foo.bar<Int>(x: 1)"))
        XCTAssertFalse(parseSuccess(
            expr, "foo(x y: 1)"))
    }
    
    func testExprSelf() {
        XCTAssertTrue(parseSuccess(
            exprSelf, "self"))
    }

    func testExprAssign() {
        XCTAssertTrue(parseSuccess(
            expr, "self.x = 1"))
    }
}
