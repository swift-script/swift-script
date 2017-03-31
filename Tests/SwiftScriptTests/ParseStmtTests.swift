import XCTest
@testable import SwiftScript

class ParseStmtTests: XCTestCase {
    func testStmtIf() {
        ParseEqual(
            stmtIf,
            "if foo {\n"
                + "  expr() \n"
                + "  bar\n"
                + "}",
            IfStatement(
                condition: .boolean(IdentifierExpression(identifier: "foo")),
                statements: [
                    ExpressionStatement(FunctionCallExpression(
                        expression: IdentifierExpression(identifier: "expr"),
                        arguments: [],
                        trailingClosure: nil
                    )),
                    ExpressionStatement(IdentifierExpression(identifier: "bar")),
                ],
                elseClause: nil
            )
        )
        
        ParseEqual(
            stmtIf,
            "if foo {\n"
                + "} else if(foo){\n"
                + "}else if foo{\n"
                + "} else {"
                + "}",
            IfStatement(
                condition: .boolean(IdentifierExpression(identifier: "foo")),
                statements: [],
                elseClause: .elseIf(IfStatement(
                    condition: .boolean(ParenthesizedExpression(expression: IdentifierExpression(identifier: "foo"))),
                    statements: [],
                    elseClause: .elseIf(IfStatement(
                        condition: .boolean(IdentifierExpression(identifier: "foo")),
                        statements: [],
                        elseClause: .else_([])
                    ))
                ))
            )
        )

        ParseEqual(
            stmtIf,
            "if let foo = bar {\n"
                + "  expr() \n"
                + "  bar\n"
                + "}",
            IfStatement(
                condition: .optionalBinding(/*isVar*/false, "foo", IdentifierExpression(identifier: "bar")),
                statements: [
                    ExpressionStatement(FunctionCallExpression(
                        expression: IdentifierExpression(identifier: "expr"),
                        arguments: [],
                        trailingClosure: nil
                    )),
                    ExpressionStatement(IdentifierExpression(identifier: "bar")),
                    ],
                elseClause: nil
            )
        )

        ParseEqual(
            stmtIf,
            "if var foo = bar {\n"
                + "  expr() \n"
                + "  bar\n"
                + "}",
            IfStatement(
                condition: .optionalBinding(/*isVar*/true, "foo", IdentifierExpression(identifier: "bar")),
                statements: [
                    ExpressionStatement(FunctionCallExpression(
                        expression: IdentifierExpression(identifier: "expr"),
                        arguments: [],
                        trailingClosure: nil
                    )),
                    ExpressionStatement(IdentifierExpression(identifier: "bar")),
                    ],
                elseClause: nil
            )
        )
    }
    
    func testStmtGuard() {
        XCTAssertTrue(parseSuccess(
            stmtGuard,
            "guard foo else {\n"
                + "  expr() \n"
                + "  bar\n"
                + "}"))
        XCTAssertTrue(parseSuccess(
            stmtGuard,
            "guard let foo = bar else {\n"
                + "  expr() \n"
                + "  bar\n"
                + "}"))
        XCTAssertTrue(parseSuccess(
            stmtGuard,
            "guard var foo = bar else {\n"
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

    func testStmtLabeled() {
        XCTAssertTrue(parseSuccess(
            stmtLabeled, "LABEL: repeat {} while foo"))
        XCTAssertTrue(parseSuccess(
            stmtLabeled, "LABEL: while foo {}"))
        XCTAssertTrue(parseSuccess(
            stmtLabeled, "LABEL: for x in s {}"))
        XCTAssertTrue(parseSuccess(
            stmtLabeled, "LABEL: if foo {}"))
        XCTAssertTrue(parseSuccess(
            stmtLabeled, "LABEL: do {}"))
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
    
    func testStmtDo() {
        XCTAssertTrue(parseSuccess(
            stmtDo, "do {}"))
    }
}
