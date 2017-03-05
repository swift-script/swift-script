import XCTest
@testable import SwiftScript

class StatementsScriptTests: XCTestCase {
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
    }
}
