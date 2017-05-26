import XCTest
import SwiftAST
@testable import SwiftKotlin

class StatementsTests: XCTestCase {
    func testForInStatement() {
//        XCTAssertEqual(try! ForInStatement(
//            item: "i",
//            collection: BinaryOperation(
//                leftOperand: IntegerLiteral(value: 0),
//                operatorSymbol: "..<",
//                rightOperand: IntegerLiteral(value: 10)
//            ),
//            statements: [
//                ExpressionStatement(FunctionCallExpression(
//                    expression: IdentifierExpression(identifier: "print"),
//                    arguments: [(nil, IdentifierExpression(identifier: "i"))],
//                    trailingClosure: nil
//                ))
//            ]
//        ).accept(KotlinTranslator(indentLevel: 0)), "for (i of range(0, 10) {\n    print(i)\n}\n")

        // indent
//        XCTAssertEqual(try! ForInStatement(
//            item: "i",
//            collection: BinaryOperation(
//                leftOperand: IntegerLiteral(value: 0),
//                operatorSymbol: "..<",
//                rightOperand: IntegerLiteral(value: 10)
//            ),
//            statements: [
//                ExpressionStatement(FunctionCallExpression(
//                    expression: IdentifierExpression(identifier: "print"),
//                    arguments: [(nil, IdentifierExpression(identifier: "i"))],
//                    trailingClosure: nil
//                ))
//            ]
//        ).accept(KotlinTranslator(indentLevel: 1)), "    for (i of range(0, 10) {\n        print(i)\n    }\n")
    }
    
    func testWhileStatement() {
        XCTAssertEqual(try! WhileStatement(
            condition: BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "<", rightOperand: IntegerLiteral(value: 42)),
            statements: [
                ExpressionStatement(FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                ))
            ]
        ).accept(KotlinTranslator(indentLevel: 0)), "while (foo < 42) {\n    print(\"Hello\")\n}\n")
        
        // indent
        XCTAssertEqual(try! WhileStatement(
            condition: BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "<", rightOperand: IntegerLiteral(value: 42)),
            statements: [
                ExpressionStatement(FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                ))
            ]
        ).accept(KotlinTranslator(indentLevel: 1)), "    while (foo < 42) {\n        print(\"Hello\")\n    }\n")
    }
    
    func testRepeatWhileStatement() {
        XCTAssertEqual(try! RepeatWhileStatement(
            statements: [
                ExpressionStatement(FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                ))
            ],
            condition: BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "<", rightOperand: IntegerLiteral(value: 42))
        ).accept(KotlinTranslator(indentLevel: 0)), "repeat {\n    print(\"Hello\")\n} while (foo < 42)\n")
        
        // indent
        XCTAssertEqual(try! RepeatWhileStatement(
            statements: [
                ExpressionStatement(FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                ))
            ],
            condition: BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "<", rightOperand: IntegerLiteral(value: 42))
        ).accept(KotlinTranslator(indentLevel: 1)), "    repeat {\n        print(\"Hello\")\n    } while (foo < 42)\n")
    }
    
    func testIfStatement() {
        XCTAssertEqual(try! IfStatement(
            condition: .boolean(BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "<", rightOperand: IntegerLiteral(value: 42))),
            statements: [
                ExpressionStatement(FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                ))
            ],
            elseClause: nil
        ).accept(KotlinTranslator(indentLevel: 0)), "if (foo < 42) {\n    print(\"Hello\")\n}\n")
        
        // if-else
        XCTAssertEqual(try! IfStatement(
            condition: .boolean(BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "<", rightOperand: IntegerLiteral(value: 42))),
            statements: [
                ExpressionStatement(FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                ))
            ],
            elseClause: .else_([
                ExpressionStatement(FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Bye"))],
                    trailingClosure: nil
                ))
            ])
        ).accept(KotlinTranslator(indentLevel: 0)), "if (foo < 42) {\n    print(\"Hello\")\n} else {\n    print(\"Bye\")\n}\n")
        
        // if-else-if
        XCTAssertEqual(try! IfStatement(
            condition: .boolean(BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "<", rightOperand: IntegerLiteral(value: 42))),
            statements: [
                ExpressionStatement(FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                ))
            ],
            elseClause: .elseIf(IfStatement(
                condition: .boolean(BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "==", rightOperand: IntegerLiteral(value: 0))),
                statements: [
                    ExpressionStatement(FunctionCallExpression(
                        expression: IdentifierExpression(identifier: "print"),
                        arguments: [(nil, StringLiteral(value: "Bye"))],
                        trailingClosure: nil
                    )),
                ],
                elseClause: nil
            ))
        ).accept(KotlinTranslator(indentLevel: 0)), "if (foo < 42) {\n    print(\"Hello\")\n} else if (foo == 0) {\n    print(\"Bye\")\n}\n")
        
        // indent
        XCTAssertEqual(try! IfStatement(
            condition: .boolean(BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "<", rightOperand: IntegerLiteral(value: 42))),
            statements: [
                ExpressionStatement(FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                ))
            ],
            elseClause: .elseIf(IfStatement(
                condition: .boolean(BinaryOperation(leftOperand: IdentifierExpression(identifier: "foo"), operatorSymbol: "==", rightOperand: IntegerLiteral(value: 0))),
                statements: [
                    ExpressionStatement(FunctionCallExpression(
                        expression: IdentifierExpression(identifier: "print"),
                        arguments: [(nil, StringLiteral(value: "Bye"))],
                        trailingClosure: nil
                    )),
                    ],
                elseClause: nil
            ))
        ).accept(KotlinTranslator(indentLevel: 1)), "    if (foo < 42) {\n        print(\"Hello\")\n    } else if (foo == 0) {\n        print(\"Bye\")\n    }\n")
        
        // optional binding
        XCTAssertEqual(try! IfStatement(
            condition: .optionalBinding(false, "foo", IdentifierExpression(identifier: "bar")),
            statements: [
                ExpressionStatement(FunctionCallExpression(expression: IdentifierExpression(identifier: "print"), arguments: [(nil, IdentifierExpression(identifier: "foo"))], trailingClosure: nil)),
            ],
            elseClause: nil
        ).accept(KotlinTranslator(indentLevel: 0)), "bar?.let { foo -> print(foo) }\n")
        
        // optional binding (let foo = foo)
        XCTAssertEqual(try! IfStatement(
            condition: .optionalBinding(false, "foo", IdentifierExpression(identifier: "foo")),
            statements: [
                ExpressionStatement(FunctionCallExpression(expression: IdentifierExpression(identifier: "print"), arguments: [(nil, IdentifierExpression(identifier: "foo"))], trailingClosure: nil)),
                ],
            elseClause: nil
        ).accept(KotlinTranslator(indentLevel: 0)), "foo?.let { foo -> print(foo) }\n")
    }
    
    func testGuardStatement() {
        XCTAssertEqual(try! GuardStatement(
            condition: .boolean(BinaryOperation(
                leftOperand: IdentifierExpression(identifier: "foo"),
                operatorSymbol: "==",
                rightOperand: IntegerLiteral(value: 42))),
            statements: [
                ReturnStatement(expression: IntegerLiteral(value: 0)),
            ]
        ).accept(KotlinTranslator(indentLevel: 0)), "if (!(foo == 42)) {\n    return 0\n}\n")
        
        // indent
        XCTAssertEqual(try! GuardStatement(
            condition: .boolean(BinaryOperation(
                leftOperand: IdentifierExpression(identifier: "foo"),
                operatorSymbol: "==",
                rightOperand: IntegerLiteral(value: 42))),
            statements: [
                ReturnStatement(expression: IntegerLiteral(value: 0)),
                ]
        ).accept(KotlinTranslator(indentLevel: 1)), "    if (!(foo == 42)) {\n        return 0\n    }\n")
        
        // optional binding
        XCTAssertEqual(try! GuardStatement(
            condition: .optionalBinding(false, "foo", IdentifierExpression(identifier: "bar")),
            statements: [
                ReturnStatement(expression: nil),
            ]
        ).accept(KotlinTranslator(indentLevel: 0)), "val foo\nif ((foo = bar) == null) {\n    return\n}\n")
        
        // optional binding (let foo = foo)
        XCTAssertEqual(try! GuardStatement(
            condition: .optionalBinding(false, "foo", IdentifierExpression(identifier: "foo")),
            statements: [
                ReturnStatement(expression: nil),
                ]
        ).accept(KotlinTranslator(indentLevel: 0)), "if (foo == null) {\n    return\n}\n")
    }
    
    func testLabeledStatement() {
        XCTAssertEqual(try! LabeledStatement(labelName: "foo", statement: WhileStatement(
            condition: BooleanLiteral(value: true),
            statements: [
                BreakStatement(labelName: "foo"),
            ]
        )).accept(KotlinTranslator(indentLevel: 0)), "foo: while (true) {\n    break foo\n}\n")
        
        // indent
        XCTAssertEqual(try! LabeledStatement(labelName: "foo", statement: WhileStatement(
            condition: BooleanLiteral(value: true),
            statements: [
                BreakStatement(labelName: "foo"),
                ]
        )).accept(KotlinTranslator(indentLevel: 1)), "    foo: while (true) {\n        break foo\n    }\n")
    }
    
    func testBreakStatement() {
        XCTAssertEqual(try! BreakStatement().accept(KotlinTranslator(indentLevel: 0)), "break\n")
        XCTAssertEqual(try! BreakStatement(labelName: "foo").accept(KotlinTranslator(indentLevel: 0)), "break foo\n")

        // indent
        XCTAssertEqual(try! BreakStatement().accept(KotlinTranslator(indentLevel: 1)), "    break\n")
    }
    
    func testContinueStatement() {
        XCTAssertEqual(try! ContinueStatement().accept(KotlinTranslator(indentLevel: 0)), "continue\n")
        XCTAssertEqual(try! ContinueStatement(labelName: "foo").accept(KotlinTranslator(indentLevel: 0)), "continue foo\n")
        
        // indent
        XCTAssertEqual(try! ContinueStatement().accept(KotlinTranslator(indentLevel: 1)), "    continue\n")
    }
    
    func testFallthroughStatement() {
        XCTAssertEqual(try! FallthroughStatement().accept(KotlinTranslator(indentLevel: 0)), "")
        
        // indent
        XCTAssertEqual(try! FallthroughStatement().accept(KotlinTranslator(indentLevel: 1)), "") // no indent because no `fallthrough` in JS
    }
    
    func testReturnStatement() {
        XCTAssertEqual(try! ReturnStatement(expression: nil).accept(KotlinTranslator(indentLevel: 0)), "return\n")
        XCTAssertEqual(try! ReturnStatement(expression: IntegerLiteral(value: 42)).accept(KotlinTranslator(indentLevel: 0)), "return 42\n")
        
        // indent
        XCTAssertEqual(try! ReturnStatement(expression: nil).accept(KotlinTranslator(indentLevel: 1)), "    return\n")
    }
    
    func testThrowStatement() {
        XCTAssertEqual(try! ThrowStatement(expression: FunctionCallExpression(
            expression: IdentifierExpression(identifier: "FooError"),
            arguments: [],
            trailingClosure: nil)
        ).accept(KotlinTranslator(indentLevel: 0)), "throw FooError()\n")
        
        // indent
        XCTAssertEqual(try! ThrowStatement(expression: FunctionCallExpression(
            expression: IdentifierExpression(identifier: "FooError"),
            arguments: [],
            trailingClosure: nil)
        ).accept(KotlinTranslator(indentLevel: 1)), "    throw FooError()\n")
    }
    
    func testDeferStatement() {
        // Unsupported
    }
    
    func testDoStatement() {
        XCTAssertEqual(try! DoStatement(
            statements: [
                ExpressionStatement(FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                ))
            ],
            catchClauses: []
        ).accept(KotlinTranslator(indentLevel: 0)), "{\n    print(\"Hello\")\n}\n")
        // TODO: catch
        
        // indent
        XCTAssertEqual(try! DoStatement(
            statements: [
                ExpressionStatement(FunctionCallExpression(
                    expression: IdentifierExpression(identifier: "print"),
                    arguments: [(nil, StringLiteral(value: "Hello"))],
                    trailingClosure: nil
                ))
            ],
            catchClauses: []
        ).accept(KotlinTranslator(indentLevel: 1)), "    {\n        print(\"Hello\")\n    }\n")
    }
}
