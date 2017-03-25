import XCTest
@testable import SwiftScript

class ExpressionsTests: XCTestCase {
    func testIdentifierExpression() {
        XCTAssertEqual(IdentifierExpression(identifier: "foo").javaScript(with: 0), "foo")
    }
    
    func testSelfExpression() {
        XCTAssertEqual(SelfExpression().javaScript(with: 0), "this")
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
            statements: [ExpressionStatement(IntegerLiteral(value: 42))]
        ).javaScript(with: 0), "() => 42")
        
        // multiple statments
        XCTAssertEqual(ClosureExpression(
            arguments: [],
            hasThrows: false,
            result: nil,
            statements: [
                DeclarationStatement(ConstantDeclaration(isStatic: false, name: "foo", type: TypeIdentifier­(names: ["Int"]), expression: IntegerLiteral(value: 42))),
                ReturnStatement(expression: IdentifierExpression(identifier: "foo"))
            ]
        ).javaScript(with: 0), "() => {\n    const foo = 42;\n    return foo;\n}")
        
        // indentLevel = 1
        XCTAssertEqual(ClosureExpression(
            arguments: [],
            hasThrows: false,
            result: nil,
            statements: [
                DeclarationStatement(ConstantDeclaration(isStatic: false, name: "foo", type: TypeIdentifier­(names: ["Int"]), expression: IntegerLiteral(value: 42))),
                ReturnStatement(expression: IdentifierExpression(identifier: "foo"))
            ]
        ).javaScript(with: 1), "() => {\n        const foo = 42;\n        return foo;\n    }")
        
        // throws
        XCTAssertEqual(ClosureExpression(
            arguments: [],
            hasThrows: true,
            result: nil,
            statements: [ExpressionStatement(IntegerLiteral(value: 42))]
        ).javaScript(with: 0), "() => 42")
        
        // arguments
        XCTAssertEqual(ClosureExpression(
            arguments: [("x", nil), ("y", nil)],
            hasThrows: false,
            result: nil,
            statements: [ExpressionStatement(BinaryOperation(
                leftOperand: IdentifierExpression(identifier: "x"),
                operatorSymbol: "+",
                rightOperand: IdentifierExpression(identifier: "y")
            ))]
        ).javaScript(with: 0), "(x, y) => x + y")
        
        // arguments with types
        XCTAssertEqual(ClosureExpression(
            arguments: [("x", TypeIdentifier­(names: ["Int"])), ("y", TypeIdentifier­(names: ["Int"]))],
            hasThrows: false,
            result: TypeIdentifier­(names: ["Int"]),
            statements: [ExpressionStatement(BinaryOperation(
                leftOperand: IdentifierExpression(identifier: "x"),
                operatorSymbol: "+",
                rightOperand: IdentifierExpression(identifier: "y")
                ))]
            ).javaScript(with: 0), "(x, y) => x + y")
    }
    
    func testParenthesizedExpression() {
        XCTAssertEqual(ParenthesizedExpression(expression: IdentifierExpression(identifier: "foo")).javaScript(with: 0), "(foo)")
    }
    
    func testTupleExpression() {
        XCTAssertEqual(TupleExpression(elements: [
            (nil, IntegerLiteral(value: 2)),
            (nil, IntegerLiteral(value: 3)),
            (nil, IntegerLiteral(value: 5)),
        ]).javaScript(with: 0), "[2, 3, 5]")
        
        // labels
        XCTAssertEqual(TupleExpression(elements: [
            ("foo", IntegerLiteral(value: 2)),
            ("bar", IntegerLiteral(value: 3)),
            ("baz", IntegerLiteral(value: 5)),
        ]).javaScript(with: 0), "[2, 3, 5]")
    }
    
    func testWildcardExpression() {
        XCTAssertEqual(WildcardExpression().javaScript(with: 0), "_")
    }
    
    func testFunctionCallExpression() {
        XCTAssertEqual(FunctionCallExpression(
            expression: IdentifierExpression(identifier: "foo"),
            arguments: [],
            trailingClosure: nil
        ).javaScript(with: 0), "foo()")
        
        // new
        XCTAssertEqual(FunctionCallExpression(
            expression: IdentifierExpression(identifier: "Foo"),
            arguments: [],
            trailingClosure: nil
        ).javaScript(with: 0), "new Foo()")
        
        // arguments
        XCTAssertEqual(FunctionCallExpression(
            expression: IdentifierExpression(identifier: "foo"),
            arguments: [
                (nil, IntegerLiteral(value: 42)),
                (nil, StringLiteral(value: "xyz")),
            ],
            trailingClosure: nil
        ).javaScript(with: 0), "foo(42, \"xyz\")")
        
        // labels
        XCTAssertEqual(FunctionCallExpression(
            expression: IdentifierExpression(identifier: "foo"),
            arguments: [
                ("bar", IntegerLiteral(value: 42)),
                ("baz", StringLiteral(value: "xyz")),
            ],
            trailingClosure: nil
        ).javaScript(with: 0), "foo(42, \"xyz\")")

        // trailing closures
        XCTAssertEqual(FunctionCallExpression(
            expression: IdentifierExpression(identifier: "foo"),
            arguments: [
                (nil, IntegerLiteral(value: 42)),
                (nil, StringLiteral(value: "xyz")),
                ],
            trailingClosure: ClosureExpression(arguments: [], hasThrows: false, result: nil, statements: [])
        ).javaScript(with: 0), "foo(42, \"xyz\", () => {})")
        
        // calls just after a closure expression
        XCTAssertEqual(FunctionCallExpression(
            expression: ClosureExpression(arguments: [], hasThrows: false, result: nil, statements: [
                ExpressionStatement(IntegerLiteral(value: 42)),
            ]),
            arguments: [],
            trailingClosure: nil
        ).javaScript(with: 0), "(() => 42)()")
    }
    
    func testInitializerExpression() {
        // `super.init`
        XCTAssertEqual(ExplicitMemberExpression(expression: SuperclassExpression(), member: "init").javaScript(with: 0), "super")
    }
    
    func testExplicitMemberExpression() {
        XCTAssertEqual(ExplicitMemberExpression(expression: IdentifierExpression(identifier: "foo"), member: "bar").javaScript(with: 0), "foo.bar")
    }
    
    func testDynamicTypeExpression() {
        // Unsupported
    }
    
    func testSubscriptExpression() {
        XCTAssertEqual(SubscriptExpression(
            expression: IdentifierExpression(identifier: "foo"),
            arguments: [IntegerLiteral(value: 42)]
        ).javaScript(with: 0), "foo[42]")
        
        // calls just after a closure expression
        XCTAssertEqual(SubscriptExpression(
            expression: ClosureExpression(arguments: [], hasThrows: false, result: nil, statements: [
                ExpressionStatement(IntegerLiteral(value: 42)),
                ]),
            arguments: [IntegerLiteral(value: 0)]
        ).javaScript(with: 0), "(() => 42)[0]")
    }
    
    func testOptionalChainingExpression() {
        XCTAssertEqual(ExplicitMemberExpression(
            expression: PostfixUnaryOperation(
                operand: IdentifierExpression(identifier: "foo"),
                operatorSymbol: "?"
            ),
            member: "bar"
        ).javaScript(with: 0), "q(foo, (x) => x.bar)")
        
        XCTAssertEqual(SubscriptExpression(
            expression: PostfixUnaryOperation(
                operand: IdentifierExpression(identifier: "foo"),
                operatorSymbol: "?"
            ),
            arguments: [IntegerLiteral(value: 0)]
        ).javaScript(with: 0), "q(foo, (x) => x[0])")
        
        XCTAssertEqual(FunctionCallExpression(
            expression: PostfixUnaryOperation(
                operand: IdentifierExpression(identifier: "foo"),
                operatorSymbol: "?"
            ),
            arguments: [],
            trailingClosure: nil
        ).javaScript(with: 0), "q(foo, (x) => x())")
    }
}
