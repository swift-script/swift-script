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
            exprIdentifier, "$12"))
        XCTAssertTrue(parseSuccess(
            exprIdentifier, "foo<A, B>"))
        XCTAssertFalse(parseSuccess(
            exprIdentifier, "self"))
        XCTAssertFalse(parseSuccess(
            exprIdentifier, "`$1`"))
    }
    
    func testExprExplicitMember() {
        XCTAssertTrue(parseSuccess(
            expr, "foo.bar"))
        XCTAssertTrue(parseSuccess(
            expr, "foo.bar<A>"))
    }
    
    func testExprCall() {
        XCTAssertTrue(parseSuccess(
            expr, "foo(x)"))
        XCTAssertTrue(parseSuccess(
            expr, "foo.bar<Int>(x: 1)"))
        XCTAssertTrue(parseSuccess(
            expr, "foo(x: 1) { x in }"))
        XCTAssertFalse(parseSuccess(
            expr, "foo(x y: 1)"))
    }

    func testExprTrailingClosure() {
        XCTAssertTrue(parseSuccess(
            expr, "foo {}"))
        XCTAssertTrue(parseSuccess(
            expr, "foo.bar { x, y in (x, y) }"))
    }
    
    func testExprSubscript() {
        XCTAssertTrue(parseSuccess(
            expr, "foo[x]"))
        XCTAssertTrue(parseSuccess(
            expr, "foo.bar[1, 2]"))
    }

    func testExprPostixUnary() {
        XCTAssertTrue(parseSuccess(
            exprAtom(isBasic: false), "foo!"))
        XCTAssertTrue(parseSuccess(
            exprAtom(isBasic: false), "foo!.bar"))
        XCTAssertTrue(parseSuccess(
            exprAtom(isBasic: false), "foo?.bar"))
        XCTAssertTrue(parseSuccess(
            exprAtom(isBasic: false), "foo?()"))
        XCTAssertTrue(parseSuccess(
            exprAtom(isBasic: false), "foo?(bar)"))
        XCTAssertTrue(parseSuccess(
            exprAtom(isBasic: false), "foo?[bar]"))
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
            expr, ".foo(x: 1)"))
    }
    
    func testExprWildcard() {
        XCTAssertTrue(parseSuccess(
            exprWildcard, "_"))
        XCTAssertTrue(parseSuccess(
            expr, "_.self"))
    }
    
    func testExprSelf() {
        XCTAssertTrue(parseSuccess(
            exprSelf, "self"))
        XCTAssertTrue(parseSuccess(
            expr, "self.foo()"))
    }
    
    func testExprSuper() {
        XCTAssertTrue(parseSuccess(
            exprSuper, "super"))
        XCTAssertTrue(parseSuccess(
            expr, "super.foo()"))
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
        XCTAssertTrue(parseSuccess(
            exprClosure, "{ $0.foo[12] }"))
        XCTAssertTrue(parseSuccess(
            exprClosure, "{ let x = 1\n return $0 + 12\n}"))
    }

    func testExprAssign() {
        XCTAssertTrue(parseSuccess(
            expr, "self.x = 1"))
    }
}
