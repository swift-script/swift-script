import XCTest
@testable import SwiftScript

class ParseStmtTests: XCTestCase {
    func testStmtIf() {
        XCTAssertTrue(parseSuccess(
            stmtIf,
            "if foo {\n"
                + "  expr() \n"
                + "  bar\n"
                + "}"))
        XCTAssertTrue(parseSuccess(
            stmtIf,
            "if foo {\n"
                + "} else if(foo){\n"
                + "}else if foo{\n"
                + "} else {"
                + "}"))
    }
    
    func testStmtGuard() {
        XCTAssertTrue(parseSuccess(
            stmtGuard,
            "guard foo else {\n"
                + "  expr() \n"
                + "  bar\n"
                + "}"))
    }
    
    func testStmtWhile() {
        XCTAssertTrue(parseSuccess(
            stmtWhile,
            "while foo {\n"
                + "  expr() \n"
                + "  bar\n"
                + "}"))
    }
    
    func testStmtRepeatWhile() {
        XCTAssertTrue(parseSuccess(
            stmtRepeatWhile,
            "repeat {\n"
                + "  expr() \n"
                + "  bar\n"
                + "} while foo"))
    }

    func testStmtForIn() {
        XCTAssertTrue(parseSuccess(
            stmtForIn,
            "for x in y {\n}"))
        XCTAssertTrue(parseSuccess(
            stmtForIn,
            "for x in[1,2,3]{}"))
    }

    func testStmtBreak() {
        XCTAssertTrue(parseSuccess(
            stmtBreak, "break"))
        XCTAssertTrue(parseSuccess(
            stmtBreak, "break LABEL"))
        XCTAssertFalse(parseSuccess(
            stmtBreak, "break 23"))
        XCTAssertFalse(parseSuccess(
            stmtBreak, "breakLABEL"))
        XCTAssertFalse(parseSuccess(
            stmtBreak, "break(LABEL)"))
        XCTAssertFalse(parseSuccess(
            stmtBreak, "break (LABEL)"))
    }
    
    func testStmtContinue() {
        XCTAssertTrue(parseSuccess(
            stmtContinue, "continue"))
        XCTAssertTrue(parseSuccess(
            stmtContinue, "continue LABEL"))
        XCTAssertFalse(parseSuccess(
            stmtContinue, "continue 42"))
        XCTAssertFalse(parseSuccess(
            stmtContinue, "continueLABEL"))
        XCTAssertFalse(parseSuccess(
            stmtContinue, "continue(LABEL)"))
        XCTAssertFalse(parseSuccess(
            stmtContinue, "continue (LABEL)"))
    }
    
    func testStmtFallthrough() {
        XCTAssertTrue(parseSuccess(
            stmtFallthrough, "fallthrough"))
        XCTAssertFalse(parseSuccess(
            stmtFallthrough, "fallthrough LABEL"))
    }

    func testStmtReturn() {
        XCTAssertTrue(parseSuccess(
            stmtReturn, "return"))
        XCTAssertTrue(parseSuccess(
            stmtReturn, "return(1)"))
        XCTAssertTrue(parseSuccess(
            stmtReturn, "return 1"))
    }
    
    func testStmtThrow() {
        XCTAssertTrue(parseSuccess(
            stmtThrow, "throw foo"))
        XCTAssertTrue(parseSuccess(
            stmtThrow, "throw(foo)"))
        XCTAssertFalse(parseSuccess(
            stmtThrow, "throw"))
    }
}
