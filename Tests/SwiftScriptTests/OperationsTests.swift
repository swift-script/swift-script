import XCTest
@testable import SwiftScript

class OperationsTests: XCTestCase {
    func testBinaryOperation() {
        XCTAssertEqual(BinaryOperation(
            leftOperand: IntegerLiteral(value: 2),
            operatorSymbol: "+",
            rightOperand: IntegerLiteral(value: 3)
        ).javaScript(with: 0), "2 + 3")
    }

    func testPrefixUnaryOperation() {
        XCTAssertEqual(PrefixUnaryOperation(
            operatorSymbol: "!",
            operand: BooleanLiteral(value: true)
            ).javaScript(with: 0), "!true")
        
        XCTAssertEqual(PrefixUnaryOperation(
            operatorSymbol: "try",
            operand: FunctionCallExpression(expression: IdentifierExpression(identifier: "foo"), arguments: [], trailingClosure: nil)
        ).javaScript(with: 0), "foo()")
        
        XCTAssertEqual(PrefixUnaryOperation(
            operatorSymbol: "try!",
            operand: FunctionCallExpression(expression: IdentifierExpression(identifier: "foo"), arguments: [], trailingClosure: nil)
            ).javaScript(with: 0), "tryx(foo())")
    }
    
    func testPostfixUnaryOperation() {
        XCTAssertEqual(PostfixUnaryOperation(
            operand: IdentifierExpression(identifier: "foo"),
            operatorSymbol: "!"
        ).javaScript(with: 0), "x(foo)")
    }
    
    func testTernaryOperation() {
        XCTAssertEqual(TernaryOperation(
            firstOperand: IdentifierExpression(identifier: "foo"),
            secondOperand: IntegerLiteral(value: 2),
            thirdOperand: IntegerLiteral(value: 3)
        ).javaScript(with: 0), "foo ? 2 : 3")
    }
}
