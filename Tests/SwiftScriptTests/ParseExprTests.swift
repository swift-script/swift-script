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
    
    func testExprParen() {
        XCTAssertTrue(parseSuccess(
            exprParenthesized, "(x)"))
        XCTAssertTrue(parseSuccess(
            exprParenthesized, "(foo.bar())"))
    }
    
    func testExprTuple() {
        XCTAssertTrue(parseSuccess(
            exprTuple, "(x, 1)"))
        XCTAssertTrue(parseSuccess(
            exprTuple, "(foo: 1, bar: 2)"))
    }
    
    func testExprImplicitMember() {
        XCTAssertTrue(parseSuccess(
            exprImplicitMember, ".foo"))
        XCTAssertTrue(parseSuccess(
            exprAtom, ".foo(x: 1)"))
    }
    
    func testExprWildcard() {
        XCTAssertTrue(parseSuccess(
            exprWildcard, "_"))
        XCTAssertTrue(parseSuccess(
            exprAtom, "_.self"))
    }
    
    func testExprSelf() {
        XCTAssertTrue(parseSuccess(
            exprSelf, "self"))
        XCTAssertTrue(parseSuccess(
            exprAtom, "self.foo()"))
    }
    
    func testExprSuper() {
        XCTAssertTrue(parseSuccess(
            exprSuper, "super"))
        XCTAssertTrue(parseSuccess(
            exprAtom, "super.foo()"))
    }

    func testExprClosure() {
        XCTAssertTrue(parseSuccess(
            exprClosure, "{}"))
        XCTAssertTrue(parseSuccess(
            exprClosure, "{ _ in x }"))
        XCTAssertTrue(parseSuccess(
            exprClosure, "{ x in }"))
        XCTAssertTrue(parseSuccess(
            exprClosure, "{ x, y in }"))
        XCTAssertTrue(parseSuccess(
            exprClosure, "{ (x, y) in }"))
        XCTAssertTrue(parseSuccess(
            exprClosure, "{ (x: Int, y: Int) in }"))
        XCTAssertTrue(parseSuccess(
            exprClosure, "{ (x: Int, y: Int) -> Int in 1 }"))
        XCTAssertTrue(parseSuccess(
            exprClosure, "{ (x: Int, y: Int) throws -> Int in 1 }"))
    }

    func testExprAssign() {
        XCTAssertTrue(parseSuccess(
            expr, "self.x = 1"))
    }
}
