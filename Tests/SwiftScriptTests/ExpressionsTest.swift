import XCTest
@testable import SwiftScript

class ExpressionsTests: XCTestCase {
    func testIdentifierExpression() {
        XCTAssertEqual(try! IdentifierExpression(identifier: "foo").accept(JavaScriptTranslator(indentLevel: 0)), "foo")
    }
    
    func testSelfExpression() {
        XCTAssertEqual(try! SelfExpression().accept(JavaScriptTranslator(indentLevel: 0)), "this")
    }

    func testSuperclassExpression() {
        XCTAssertEqual(try! SuperclassExpression().accept(JavaScriptTranslator(indentLevel: 0)), "super")
    }
    
    func testClosureExpression() {
        XCTAssertEqual(try! ClosureExpression(
            arguments: [],
            hasThrows: false,
            result: nil,
            statements: []
        ).accept(JavaScriptTranslator(indentLevel: 0)), "() => {}")
        
        // single expression
        XCTAssertEqual(try! ClosureExpression(
            arguments: [],
            hasThrows: false,
            result: nil,
            statements: [ExpressionStatement(IntegerLiteral(value: 42))]
        ).accept(JavaScriptTranslator(indentLevel: 0)), "() => 42")
        
        // multiple statments
        XCTAssertEqual(try! ClosureExpression(
            arguments: [],
            hasThrows: false,
            result: nil,
            statements: [
                DeclarationStatement(ConstantDeclaration(isStatic: false, name: "foo", type: TypeIdentifier(names: ["Int"]), expression: IntegerLiteral(value: 42))),
                ReturnStatement(expression: IdentifierExpression(identifier: "foo"))
            ]
        ).accept(JavaScriptTranslator(indentLevel: 0)), "() => {\n    const foo = 42;\n    return foo;\n}")
        
        // indentLevel = 1
        XCTAssertEqual(try! ClosureExpression(
            arguments: [],
            hasThrows: false,
            result: nil,
            statements: [
                DeclarationStatement(ConstantDeclaration(isStatic: false, name: "foo", type: TypeIdentifier(names: ["Int"]), expression: IntegerLiteral(value: 42))),
                ReturnStatement(expression: IdentifierExpression(identifier: "foo"))
            ]
        ).accept(JavaScriptTranslator(indentLevel: 1)), "() => {\n        const foo = 42;\n        return foo;\n    }")
        
        // throws
        XCTAssertEqual(try! ClosureExpression(
            arguments: [],
            hasThrows: true,
            result: nil,
            statements: [ExpressionStatement(IntegerLiteral(value: 42))]
        ).accept(JavaScriptTranslator(indentLevel: 0)), "() => 42")
        
        // arguments
        XCTAssertEqual(try! ClosureExpression(
            arguments: [("x", nil), ("y", nil)],
            hasThrows: false,
            result: nil,
            statements: [ExpressionStatement(BinaryOperation(
                leftOperand: IdentifierExpression(identifier: "x"),
                operatorSymbol: "+",
                rightOperand: IdentifierExpression(identifier: "y")
            ))]
        ).accept(JavaScriptTranslator(indentLevel: 0)), "(x, y) => x + y")
        
        // arguments with types
        XCTAssertEqual(try! ClosureExpression(
            arguments: [("x", TypeIdentifier(names: ["Int"])), ("y", TypeIdentifier(names: ["Int"]))],
            hasThrows: false,
            result: TypeIdentifier(names: ["Int"]),
            statements: [ExpressionStatement(BinaryOperation(
                leftOperand: IdentifierExpression(identifier: "x"),
                operatorSymbol: "+",
                rightOperand: IdentifierExpression(identifier: "y")
                ))]
            ).accept(JavaScriptTranslator(indentLevel: 0)), "(x, y) => x + y")
    }
    
    func testParenthesizedExpression() {
        XCTAssertEqual(try! ParenthesizedExpression(expression: IdentifierExpression(identifier: "foo")).accept(JavaScriptTranslator(indentLevel: 0)), "(foo)")
    }
    
    func testTupleExpression() {
        XCTAssertEqual(try! TupleExpression(elements: [
            (nil, IntegerLiteral(value: 2)),
            (nil, IntegerLiteral(value: 3)),
            (nil, IntegerLiteral(value: 5)),
        ]).accept(JavaScriptTranslator(indentLevel: 0)), "[2, 3, 5]")
        
        // labels
        XCTAssertEqual(try! TupleExpression(elements: [
            ("foo", IntegerLiteral(value: 2)),
            ("bar", IntegerLiteral(value: 3)),
            ("baz", IntegerLiteral(value: 5)),
        ]).accept(JavaScriptTranslator(indentLevel: 0)), "[2, 3, 5]")
    }
    
    func testWildcardExpression() {
        XCTAssertEqual(try! WildcardExpression().accept(JavaScriptTranslator(indentLevel: 0)), "_")
    }
    
    func testFunctionCallExpression() {
        XCTAssertEqual(try! FunctionCallExpression(
            expression: IdentifierExpression(identifier: "foo"),
            arguments: [],
            trailingClosure: nil
        ).accept(JavaScriptTranslator(indentLevel: 0)), "foo()")
        
        // new
        XCTAssertEqual(try! FunctionCallExpression(
            expression: IdentifierExpression(identifier: "Foo"),
            arguments: [],
            trailingClosure: nil
        ).accept(JavaScriptTranslator(indentLevel: 0)), "new Foo()")
        
        // arguments
        XCTAssertEqual(try! FunctionCallExpression(
            expression: IdentifierExpression(identifier: "foo"),
            arguments: [
                (nil, IntegerLiteral(value: 42)),
                (nil, StringLiteral(value: "xyz")),
            ],
            trailingClosure: nil
        ).accept(JavaScriptTranslator(indentLevel: 0)), "foo(42, \"xyz\")")
        
        // labels
        XCTAssertEqual(try! FunctionCallExpression(
            expression: IdentifierExpression(identifier: "foo"),
            arguments: [
                ("bar", IntegerLiteral(value: 42)),
                ("baz", StringLiteral(value: "xyz")),
            ],
            trailingClosure: nil
        ).accept(JavaScriptTranslator(indentLevel: 0)), "foo(42, \"xyz\")")

        // trailing closures
        XCTAssertEqual(try! FunctionCallExpression(
            expression: IdentifierExpression(identifier: "foo"),
            arguments: [
                (nil, IntegerLiteral(value: 42)),
                (nil, StringLiteral(value: "xyz")),
                ],
            trailingClosure: ClosureExpression(arguments: [], hasThrows: false, result: nil, statements: [])
        ).accept(JavaScriptTranslator(indentLevel: 0)), "foo(42, \"xyz\", () => {})")
        
        // calls just after a closure expression
        XCTAssertEqual(try! FunctionCallExpression(
            expression: ClosureExpression(arguments: [], hasThrows: false, result: nil, statements: [
                ExpressionStatement(IntegerLiteral(value: 42)),
            ]),
            arguments: [],
            trailingClosure: nil
        ).accept(JavaScriptTranslator(indentLevel: 0)), "(() => 42)()")
    }
    
    func testInitializerExpression() {
        // `super.init`
        XCTAssertEqual(try! ExplicitMemberExpression(expression: SuperclassExpression(), member: "init").accept(JavaScriptTranslator(indentLevel: 0)), "super")
    }
    
    func testExplicitMemberExpression() {
        XCTAssertEqual(try! ExplicitMemberExpression(expression: IdentifierExpression(identifier: "foo"), member: "bar").accept(JavaScriptTranslator(indentLevel: 0)), "foo.bar")
    }
    
    func testDynamicTypeExpression() {
        // Unsupported
    }
    
    func testSubscriptExpression() {
        XCTAssertEqual(try! SubscriptExpression(
            expression: IdentifierExpression(identifier: "foo"),
            arguments: [IntegerLiteral(value: 42)]
        ).accept(JavaScriptTranslator(indentLevel: 0)), "foo[42]")
        
        // calls just after a closure expression
        XCTAssertEqual(try! SubscriptExpression(
            expression: ClosureExpression(arguments: [], hasThrows: false, result: nil, statements: [
                ExpressionStatement(IntegerLiteral(value: 42)),
                ]),
            arguments: [IntegerLiteral(value: 0)]
        ).accept(JavaScriptTranslator(indentLevel: 0)), "(() => 42)[0]")
    }
    
    func testOptionalChainingExpression() {
        XCTAssertEqual(try! ExplicitMemberExpression(
            expression: PostfixUnaryOperation(
                operand: IdentifierExpression(identifier: "foo"),
                operatorSymbol: "?"
            ),
            member: "bar"
        ).accept(JavaScriptTranslator(indentLevel: 0)), "q(foo, (x) => x.bar)")
        
        XCTAssertEqual(try! SubscriptExpression(
            expression: PostfixUnaryOperation(
                operand: IdentifierExpression(identifier: "foo"),
                operatorSymbol: "?"
            ),
            arguments: [IntegerLiteral(value: 0)]
        ).accept(JavaScriptTranslator(indentLevel: 0)), "q(foo, (x) => x[0])")
        
        XCTAssertEqual(try! FunctionCallExpression(
            expression: PostfixUnaryOperation(
                operand: IdentifierExpression(identifier: "foo"),
                operatorSymbol: "?"
            ),
            arguments: [],
            trailingClosure: nil
        ).accept(JavaScriptTranslator(indentLevel: 0)), "q(foo, (x) => x())")
    }
}
