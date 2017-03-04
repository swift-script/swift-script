import XCTest
@testable import SwiftScript

class ExpressionsTests: XCTestCase {
    func testIdentifierExpression() {
        XCTAssertEqual(IdentifierExpression(identifier: "foo").javaScript(with: 0), "foo")
    }
    
    func testSelfExpression() {
        XCTAssertEqual(SelfExpression().javaScript(with: 0), "self")
    }

    func testSuperclassExpression() {
        XCTAssertEqual(SuperclassExpression().javaScript(with: 0), "super")
    }
    
    func testClosureExpression() {
        XCTAssertEqual(ClosureExpression(
            arguments: [],
            hasThrows: false,
            result: nil,
            statements: []
        ).javaScript(with: 0), "() => {}")
        
        // single expression
        XCTAssertEqual(ClosureExpression(
            arguments: [],
            hasThrows: false,
            result: nil,
            statements: [IntegerLiteral(value: 42)]
        ).javaScript(with: 0), "() => 42")
        
        // multiple statments
        XCTAssertEqual(ClosureExpression(
            arguments: [],
            hasThrows: false,
            result: nil,
            statements: [
                ConstantDeclaration(isStatic: false, name: "foo", type: TypeIdentifier­(names: ["Int"]), expression: IntegerLiteral(value: 42)),
                ReturnStatement(expression: IdentifierExpression(identifier: "foo"))
            ]
        ).javaScript(with: 0), "() => {\n    const foo = 42;\n    return foo;\n}")
        
        // indentLevel = 1
        XCTAssertEqual(ClosureExpression(
            arguments: [],
            hasThrows: false,
            result: nil,
            statements: [
                ConstantDeclaration(isStatic: false, name: "foo", type: TypeIdentifier­(names: ["Int"]), expression: IntegerLiteral(value: 42)),
                ReturnStatement(expression: IdentifierExpression(identifier: "foo"))
            ]
        ).javaScript(with: 0), "() => {\n        const foo = 42;\n        return foo;    \n}")
        
        // throws
        XCTAssertEqual(ClosureExpression(
            arguments: [],
            hasThrows: true,
            result: nil,
            statements: [IntegerLiteral(value: 42)]
        ).javaScript(with: 0), "() => 42")
        
        // arguments
        XCTAssertEqual(ClosureExpression(
            arguments: [("x", nil), ("y", nil)],
            hasThrows: false,
            result: nil,
            statements: [BinaryOperation(
                leftOperand: IdentifierExpression(identifier: "x"),
                operatorSymbol: "+",
                rightOperand: IdentifierExpression(identifier: "y")
            )]
        ).javaScript(with: 0), "(x, y) => x + y")
        
        // arguments with types
        XCTAssertEqual(ClosureExpression(
            arguments: [("x", TypeIdentifier­(names: ["Int"])), ("y", TypeIdentifier­(names: ["Int"]))],
            hasThrows: false,
            result: TypeIdentifier­(names: ["Int"]),
            statements: [BinaryOperation(
                leftOperand: IdentifierExpression(identifier: "x"),
                operatorSymbol: "+",
                rightOperand: IdentifierExpression(identifier: "y")
                )]
            ).javaScript(with: 0), "(x, y) => x + y")
    }
}
