import XCTest
import SwiftAST
@testable import SwiftKotlin

class OperationsTests: XCTestCase {
    func testBinaryOperation() {
        XCTAssertEqual(try! BinaryOperation(
            leftOperand: IntegerLiteral(value: 2),
            operatorSymbol: "+",
            rightOperand: IntegerLiteral(value: 3)
        ).accept(KotlinTranslator(indentLevel: 0)), "2 + 3")
    }

    func testPrefixUnaryOperation() {
        XCTAssertEqual(try! PrefixUnaryOperation(
            operatorSymbol: "!",
            operand: BooleanLiteral(value: true)
            ).accept(KotlinTranslator(indentLevel: 0)), "!true")
        
        XCTAssertEqual(try! PrefixUnaryOperation(
            operatorSymbol: "try",
            operand: FunctionCallExpression(expression: IdentifierExpression(identifier: "foo"), arguments: [], trailingClosure: nil)
        ).accept(KotlinTranslator(indentLevel: 0)), "foo()")
        
//        XCTAssertEqual(try! PrefixUnaryOperation(
//            operatorSymbol: "try!",
//            operand: FunctionCallExpression(expression: IdentifierExpression(identifier: "foo"), arguments: [], trailingClosure: nil)
//            ).accept(KotlinTranslator(indentLevel: 0)), "tryx(foo())")
    }
    
    func testPostfixUnaryOperation() {
//        XCTAssertEqual(try! PostfixUnaryOperation(
//            operand: IdentifierExpression(identifier: "foo"),
//            operatorSymbol: "!"
//        ).accept(KotlinTranslator(indentLevel: 0)), "x(foo)")
    }
    
    func testTernaryOperation() {
        XCTAssertEqual(try! TernaryOperation(
            firstOperand: IdentifierExpression(identifier: "foo"),
            secondOperand: IntegerLiteral(value: 2),
            thirdOperand: IntegerLiteral(value: 3)
        ).accept(KotlinTranslator(indentLevel: 0)), "foo ? 2 : 3")
    }
}
