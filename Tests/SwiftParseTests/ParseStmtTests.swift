import XCTest
import SwiftAST
@testable import SwiftParse

class ParseStmtTests: XCTestCase {
    func testStmtIf() {
        ParseAssertEqual(
            stmt,
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
        
        ParseAssertEqual(
            stmt,
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

        ParseAssertEqual(
            stmt,
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

        ParseAssertEqual(
            stmt,
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
        ParseAssertEqual(
            stmt,
            "guard foo else {\n"
                + "  expr() \n"
                + "  bar\n"
                + "}",
            GuardStatement(
                condition: .boolean(IdentifierExpression(identifier: "foo")),
                statements: [
                    ExpressionStatement(FunctionCallExpression(
                        expression: IdentifierExpression(identifier: "expr"),
                        arguments: [],
                        trailingClosure: nil
                    )),
                    ExpressionStatement(IdentifierExpression(identifier: "bar")),
                ]
            )
        )
        ParseAssertEqual(
            stmt,
            "guard let foo = bar else {\n"
                + "  expr() \n"
                + "  bar\n"
                + "}",
            GuardStatement(
                condition: .optionalBinding(false, "foo", IdentifierExpression(identifier: "bar")),
                statements: [
                    ExpressionStatement(FunctionCallExpression(
                        expression: IdentifierExpression(identifier: "expr"),
                        arguments: [],
                        trailingClosure: nil
                    )),
                    ExpressionStatement(IdentifierExpression(identifier: "bar")),
                ]
            )
        )
        ParseAssertEqual(
            stmt,
            "guard var foo = bar else {\n"
                + "  expr() \n"
                + "  bar\n"
                + "}",
            GuardStatement(
                condition: .optionalBinding(true, "foo", IdentifierExpression(identifier: "bar")),
                statements: [
                    ExpressionStatement(FunctionCallExpression(
                        expression: IdentifierExpression(identifier: "expr"),
                        arguments: [],
                        trailingClosure: nil
                    )),
                    ExpressionStatement(IdentifierExpression(identifier: "bar")),
                ]
            )
        )
    }
    
    func testStmtWhile() {
        ParseAssertEqual(
            stmt,
            "while foo {\n"
                + "  expr() \n"
                + "  bar\n"
                + "}",
            WhileStatement(
                condition: IdentifierExpression(identifier: "foo"),
                statements: [
                    ExpressionStatement(FunctionCallExpression(
                        expression: IdentifierExpression(identifier: "expr"),
                        arguments: [],
                        trailingClosure: nil
                    )),
                    ExpressionStatement(IdentifierExpression(identifier: "bar")),
                ]
            )
        )
    }
    
    func testStmtRepeatWhile() {
        ParseAssertEqual(
            stmt,
            "repeat {\n"
                + "  expr() \n"
                + "  bar\n"
                + "} while foo",
            RepeatWhileStatement(
                statements: [
                    ExpressionStatement(FunctionCallExpression(
                        expression: IdentifierExpression(identifier: "expr"),
                        arguments: [],
                        trailingClosure: nil
                    )),
                    ExpressionStatement(IdentifierExpression(identifier: "bar")),
                ],
                condition: IdentifierExpression(identifier: "foo")
            )
        )
    }

    func testStmtForIn() {
        ParseAssertEqual(
            stmt,
            "for x in y {\n}",
            ForInStatement(
                item: "x",
                collection: IdentifierExpression(identifier: "y"),
                statements: []
            )
        )
        ParseAssertEqual(
            stmt,
            "for x in[1,2,3]{}",
            ForInStatement(
                item: "x",
                collection: ArrayLiteral(value: [
                    IntegerLiteral(value: 1),
                    IntegerLiteral(value: 2),
                    IntegerLiteral(value: 3),
                ]),
                statements: []
            )
        )
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
        ParseAssertEqual(
            stmt,
            "break",
            BreakStatement(labelName: nil)
        )
        ParseAssertEqual(
            stmt,
            "break LABEL",
            BreakStatement(labelName: "LABEL")
        )
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
        ParseAssertEqual(
            stmt,
            "continue",
            ContinueStatement(labelName: nil)
        )
        ParseAssertEqual(
            stmt,
            "continue LABEL",
            ContinueStatement(labelName: "LABEL")
        )
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
        ParseAssertEqual(
            stmt,
            "fallthrough",
            FallthroughStatement()
        )
        XCTAssertFalse(parseSuccess(
            stmtFallthrough, "fallthrough LABEL"))
    }

    func testStmtReturn() {
        ParseAssertEqual(
            stmt,
            "return",
            ReturnStatement(expression: nil)
        )
        ParseAssertEqual(
            stmt,
            "return(1)",
            ReturnStatement(
                expression: ParenthesizedExpression(
                    expression: IntegerLiteral(value: 1)
                )
            )
        )
        ParseAssertEqual(
            stmt,
            "return 1",
            ReturnStatement(expression: IntegerLiteral(value: 1))
        )
    }
    
    func testStmtThrow() {
        ParseAssertEqual(
            stmt,
            "throw foo",
            ThrowStatement(expression: IdentifierExpression(identifier: "foo"))
        )
        ParseAssertEqual(
            stmt,
            "throw(foo)",
            ThrowStatement(
                expression: ParenthesizedExpression(
                    expression: IdentifierExpression(identifier: "foo")
                )
            )
        )
        XCTAssertFalse(parseSuccess(
            stmtThrow, "throw"))
    }
    
    func testStmtDo() {
        ParseAssertEqual(
            stmt,
            "do {}",
            DoStatement(statements: [], catchClauses: [])
        )
    }
}
