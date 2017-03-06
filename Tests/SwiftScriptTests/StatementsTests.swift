import XCTest
@testable import SwiftScript

class StatementsTests: XCTestCase {
    func testForInStatement() {
        XCTAssertEqual(ForInStatement(
            item: "i",
            collection: BinaryOperation(
                leftOperand: IntegerLiteral(value: 0),
                operatorSymbol: "..<",
                rightOperand: IntegerLiteral(value: 10)
            ),
            statements: [
                FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, IdentifierExpression(identifier: "i"))],
                    trailingClosure: nil
                )
            ]
        ).javaScript(with: 0), "for (i of range(0, 10) {\n    console.log(i);\n}\n")
        
        // indent
        XCTAssertEqual(ForInStatement(
            item: "i",
            collection: BinaryOperation(
                leftOperand: IntegerLiteral(value: 0),
                operatorSymbol: "..<",
                rightOperand: IntegerLiteral(value: 10)
            ),
            statements: [
                FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, IdentifierExpression(identifier: "i"))],
                    trailingClosure: nil
                )
            ]
        ).javaScript(with: 1), "    for (i of range(0, 10) {\n        console.log(i);\n    }\n")
    }
    
    func testWhileStatement() {
        XCTAssertEqual(WhileStatement(
            condition: BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "<", rightOperand: IntegerLiteral(value: 42)),
            statements: [
                FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                )
            ]
        ).javaScript(with: 0), "while (foo < 42) {\n    console.log(\"Hello\");\n}\n")
        
        // indent
        XCTAssertEqual(WhileStatement(
            condition: BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "<", rightOperand: IntegerLiteral(value: 42)),
            statements: [
                FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                )
            ]
        ).javaScript(with: 1), "    while (foo < 42) {\n        console.log(\"Hello\");\n    }\n")
    }
    
    func testRepeatWhileStatement() {
        XCTAssertEqual(RepeatWhileStatement(
            statements: [
                FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                )
            ],
            condition: BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "<", rightOperand: IntegerLiteral(value: 42))
        ).javaScript(with: 0), "repeat {\n    console.log(\"Hello\");\n} while (foo < 42)\n")
        
        // indent
        XCTAssertEqual(RepeatWhileStatement(
            statements: [
                FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                )
            ],
            condition: BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "<", rightOperand: IntegerLiteral(value: 42))
        ).javaScript(with: 1), "    repeat {\n        console.log(\"Hello\");\n    } while (foo < 42)\n")
    }
    
    func testIfStatement() {
        XCTAssertEqual(IfStatement(
            condition: BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "<", rightOperand: IntegerLiteral(value: 42)),
            statements: [
                FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                )
            ],
            elseClause: nil
        ).javaScript(with: 0), "if (foo < 42) {\n    console.log(\"Hello\");\n}\n")
        
        // if-else
        XCTAssertEqual(IfStatement(
            condition: BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "<", rightOperand: IntegerLiteral(value: 42)),
            statements: [
                FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                )
            ],
            elseClause: .else_([
                FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Bye"))],
                    trailingClosure: nil
                )
            ])
        ).javaScript(with: 0), "if (foo < 42) {\n    console.log(\"Hello\");\n} else {\n    console.log(\"Bye\");\n}\n")
        
        // if-else-if
        XCTAssertEqual(IfStatement(
            condition: BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "<", rightOperand: IntegerLiteral(value: 42)),
            statements: [
                FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                )
            ],
            elseClause: .elseIf(IfStatement(
                condition: BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "==", rightOperand: IntegerLiteral(value: 0)),
                statements: [
                    FunctionCallExpression(
                        expression: IdentifierExpression(identifier: "print"),
                        arguments: [(nil, StringLiteral(value: "Bye"))],
                        trailingClosure: nil
                    ),
                ],
                elseClause: nil
            ))
        ).javaScript(with: 0), "if (foo < 42) {\n    console.log(\"Hello\");\n} else if (foo == 0) {\n    console.log(\"Bye\");\n}\n")
        
        // indent
        XCTAssertEqual(IfStatement(
            condition: BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "<", rightOperand: IntegerLiteral(value: 42)),
            statements: [
                FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                )
            ],
            elseClause: .elseIf(IfStatement(
                condition: BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "==", rightOperand: IntegerLiteral(value: 0)),
                statements: [
                    FunctionCallExpression(
                        expression: IdentifierExpression(identifier: "print"),
                        arguments: [(nil, StringLiteral(value: "Bye"))],
                        trailingClosure: nil
                    ),
                    ],
                elseClause: nil
            ))
        ).javaScript(with: 1), "    if (foo < 42) {\n        console.log(\"Hello\");\n    } else if (foo == 0) {\n        console.log(\"Bye\");\n    }\n")
    }
    
    func testGuardStatement() {
        XCTAssertEqual(GuardStatement(
            condition: BinaryOperation(
                leftOperand: IdentifierExpression(identifier: "foo"),
                operatorSymbol: "==",
                rightOperand: IntegerLiteral(value: 42)),
            statements: [
                ReturnStatement(expression: IntegerLiteral(value: 0)),
            ]
        ).javaScript(with: 0), "if (!(foo == 42)) {\n    return 0;\n}\n")
        
        // indent
        XCTAssertEqual(GuardStatement(
            condition: BinaryOperation(
                leftOperand: IdentifierExpression(identifier: "foo"),
                operatorSymbol: "==",
                rightOperand: IntegerLiteral(value: 42)),
            statements: [
                ReturnStatement(expression: IntegerLiteral(value: 0)),
                ]
        ).javaScript(with: 1), "    if (!(foo == 42)) {\n        return 0;\n    }\n")
    }
    
    func testLabeledStatement() {
        XCTAssertEqual(LabeledStatement(labelName: "foo", statement: WhileStatement(
            condition: BooleanLiteral(value: true),
            statements: [
                BreakStatement(labelName: "foo"),
            ]
        )).javaScript(with: 0), "foo: while (true) {\n    break foo;\n}\n")
        
        // indent
        XCTAssertEqual(LabeledStatement(labelName: "foo", statement: WhileStatement(
            condition: BooleanLiteral(value: true),
            statements: [
                BreakStatement(labelName: "foo"),
                ]
        )).javaScript(with: 1), "    foo: while (true) {\n        break foo;\n    }\n")
    }
    
    func testBreakStatement() {
        XCTAssertEqual(BreakStatement().javaScript(with: 0), "break;\n")
        XCTAssertEqual(BreakStatement(labelName: "foo").javaScript(with: 0), "break foo;\n")

        // indent
        XCTAssertEqual(BreakStatement().javaScript(with: 1), "    break;\n")
    }
    
    func testContinueStatement() {
        XCTAssertEqual(ContinueStatement().javaScript(with: 0), "continue;\n")
        XCTAssertEqual(ContinueStatement(labelName: "foo").javaScript(with: 0), "continue foo;\n")
        
        // indent
        XCTAssertEqual(ContinueStatement().javaScript(with: 1), "    continue;\n")
    }
    
    func testFallthroughStatement() {
        XCTAssertEqual(FallthroughStatement().javaScript(with: 0), "")
        
        // indent
        XCTAssertEqual(FallthroughStatement().javaScript(with: 1), "") // no indent because no `fallthrough` in JS
    }
    
    func testReturnStatement() {
        XCTAssertEqual(ReturnStatement(expression: nil).javaScript(with: 0), "return;\n")
        XCTAssertEqual(ReturnStatement(expression: IntegerLiteral(value: 42)).javaScript(with: 0), "return 42;\n")
        
        // indent
        XCTAssertEqual(ReturnStatement(expression: nil).javaScript(with: 1), "    return;\n")
    }
    
    func testThrowStatement() {
        XCTAssertEqual(ThrowStatement(expression: FunctionCallExpression(
            expression: IdentifierExpression(identifier: "FooError"),
            arguments: [],
            trailingClosure: nil)
        ).javaScript(with: 0), "throw new FooError();\n")
        
        // indent
        XCTAssertEqual(ThrowStatement(expression: FunctionCallExpression(
            expression: IdentifierExpression(identifier: "FooError"),
            arguments: [],
            trailingClosure: nil)
        ).javaScript(with: 1), "    throw new FooError();\n")
    }
    
    func testDeferStatement() {
        // Unsupported
    }
    
    func testDoStatement() {
        XCTAssertEqual(DoStatement(
            statements: [
                FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                )
            ],
            catchClauses: []
        ).javaScript(with: 0), "{\n    console.log(\"Hello\");\n}\n")
        // TODO: catch
        
        // indent
        XCTAssertEqual(DoStatement(
            statements: [
                FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                )
            ],
            catchClauses: []
        ).javaScript(with: 1), "    {\n        console.log(\"Hello\");\n    }\n")
    }
}
