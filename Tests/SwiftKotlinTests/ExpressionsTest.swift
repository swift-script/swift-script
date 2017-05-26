import XCTest
import SwiftAST
@testable import SwiftKotlin

class ExpressionsTests: XCTestCase {
    func testIdentifierExpression() {
        XCTAssertEqual(try! IdentifierExpression(identifier: "foo").accept(KotlinTranslator(indentLevel: 0)), "foo")
    }
    
    func testSelfExpression() {
        XCTAssertEqual(try! SelfExpression().accept(KotlinTranslator(indentLevel: 0)), "this")
    }

    func testSuperclassExpression() {
        XCTAssertEqual(try! SuperclassExpression().accept(KotlinTranslator(indentLevel: 0)), "super")
    }
    
    func testClosureExpression() {
        XCTAssertEqual(try! ClosureExpression(
            arguments: [],
            hasThrows: false,
            result: nil,
            statements: []
        ).accept(KotlinTranslator(indentLevel: 0)), "{}")   // TODO: Check

        // single expression
        XCTAssertEqual(try! ClosureExpression(
            arguments: [],
            hasThrows: false,
            result: nil,
            statements: [ExpressionStatement(IntegerLiteral(value: 42))]
        ).accept(KotlinTranslator(indentLevel: 0)), "{ 42 }")   // TODO: Check

        // multiple statments
        XCTAssertEqual(try! ClosureExpression(
            arguments: [],
            hasThrows: false,
            result: nil,
            statements: [
                DeclarationStatement(ConstantDeclaration(isStatic: false, name: "foo", type: TypeIdentifier(names: ["Int"]), expression: IntegerLiteral(value: 42))),
                ReturnStatement(expression: IdentifierExpression(identifier: "foo"))
            ]
        ).accept(KotlinTranslator(indentLevel: 0)), "{\n    val foo: Int = 42\n    return foo\n}")
        
        // indentLevel = 1
        XCTAssertEqual(try! ClosureExpression(
            arguments: [],
            hasThrows: false,
            result: nil,
            statements: [
                DeclarationStatement(ConstantDeclaration(isStatic: false, name: "foo", type: TypeIdentifier(names: ["Int"]), expression: IntegerLiteral(value: 42))),
                ReturnStatement(expression: IdentifierExpression(identifier: "foo"))
            ]
        ).accept(KotlinTranslator(indentLevel: 1)), "{\n        val foo: Int = 42\n        return foo\n    }")
        
        // throws
        XCTAssertEqual(try! ClosureExpression(
            arguments: [],
            hasThrows: true,
            result: nil,
            statements: [ExpressionStatement(IntegerLiteral(value: 42))]
        ).accept(KotlinTranslator(indentLevel: 0)), "{ 42 }")   // TODO: Check

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
        ).accept(KotlinTranslator(indentLevel: 0)), "{ x, y -> x + y }")
        
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
            ).accept(KotlinTranslator(indentLevel: 0)), "{ x, y -> x + y }")
    }
    
    func testParenthesizedExpression() {
        XCTAssertEqual(try! ParenthesizedExpression(expression: IdentifierExpression(identifier: "foo")).accept(KotlinTranslator(indentLevel: 0)), "(foo)")
    }
    
    func testTupleExpression() {
        XCTAssertEqual(try! TupleExpression(elements: [
            (nil, IntegerLiteral(value: 2)),
            (nil, IntegerLiteral(value: 3)),
            (nil, IntegerLiteral(value: 5)),
        ]).accept(KotlinTranslator(indentLevel: 0)), "[2, 3, 5]")
        
        // labels
        XCTAssertEqual(try! TupleExpression(elements: [
            ("foo", IntegerLiteral(value: 2)),
            ("bar", IntegerLiteral(value: 3)),
            ("baz", IntegerLiteral(value: 5)),
        ]).accept(KotlinTranslator(indentLevel: 0)), "[2, 3, 5]")
    }
    
    func testWildcardExpression() {
        XCTAssertEqual(try! WildcardExpression().accept(KotlinTranslator(indentLevel: 0)), "_")
    }
    
    func testFunctionCallExpression() {
        XCTAssertEqual(try! FunctionCallExpression(
            expression: IdentifierExpression(identifier: "foo"),
            arguments: [],
            trailingClosure: nil
        ).accept(KotlinTranslator(indentLevel: 0)), "foo()")
        
        // new
        XCTAssertEqual(try! FunctionCallExpression(
            expression: IdentifierExpression(identifier: "Foo"),
            arguments: [],
            trailingClosure: nil
        ).accept(KotlinTranslator(indentLevel: 0)), "Foo()")
        
        // arguments
        XCTAssertEqual(try! FunctionCallExpression(
            expression: IdentifierExpression(identifier: "foo"),
            arguments: [
                (nil, IntegerLiteral(value: 42)),
                (nil, StringLiteral(value: "xyz")),
            ],
            trailingClosure: nil
        ).accept(KotlinTranslator(indentLevel: 0)), "foo(42, \"xyz\")")
        
        // labels
        XCTAssertEqual(try! FunctionCallExpression(
            expression: IdentifierExpression(identifier: "foo"),
            arguments: [
                ("bar", IntegerLiteral(value: 42)),
                ("baz", StringLiteral(value: "xyz")),
            ],
            trailingClosure: nil
        ).accept(KotlinTranslator(indentLevel: 0)), "foo(bar = 42, baz = \"xyz\")")

        // trailing closures
        XCTAssertEqual(try! FunctionCallExpression(
            expression: IdentifierExpression(identifier: "foo"),
            arguments: [
                (nil, IntegerLiteral(value: 42)),
                (nil, StringLiteral(value: "xyz")),
                ],
            trailingClosure: ClosureExpression(arguments: [], hasThrows: false, result: nil, statements: [])
        ).accept(KotlinTranslator(indentLevel: 0)), "foo(42, \"xyz\", {})")
        
        // calls just after a closure expression
        XCTAssertEqual(try! FunctionCallExpression(
            expression: ClosureExpression(arguments: [], hasThrows: false, result: nil, statements: [
                ExpressionStatement(IntegerLiteral(value: 42)),
            ]),
            arguments: [],
            trailingClosure: nil
        ).accept(KotlinTranslator(indentLevel: 0)), "({ 42 })()")
    }
    
    func testInitializerExpression() {
        // `super.init`
        XCTAssertEqual(try! ExplicitMemberExpression(expression: SuperclassExpression(), member: "init").accept(KotlinTranslator(indentLevel: 0)), "super")
    }
    
    func testExplicitMemberExpression() {
        XCTAssertEqual(try! ExplicitMemberExpression(expression: IdentifierExpression(identifier: "foo"), member: "bar").accept(KotlinTranslator(indentLevel: 0)), "foo.bar")
    }
    
    func testDynamicTypeExpression() {
        // Unsupported
    }
    
    func testSubscriptExpression() {
        XCTAssertEqual(try! SubscriptExpression(
            expression: IdentifierExpression(identifier: "foo"),
            arguments: [IntegerLiteral(value: 42)]
        ).accept(KotlinTranslator(indentLevel: 0)), "foo[42]")
        
        // calls just after a closure expression
        XCTAssertEqual(try! SubscriptExpression(
            expression: ClosureExpression(arguments: [], hasThrows: false, result: nil, statements: [
                ExpressionStatement(IntegerLiteral(value: 42)),
                ]),
            arguments: [IntegerLiteral(value: 0)]
        ).accept(KotlinTranslator(indentLevel: 0)), "({ 42 })[0]")
    }
    
    func testOptionalChainingExpression() {
        XCTAssertEqual(try! ExplicitMemberExpression(
            expression: PostfixUnaryOperation(
                operand: IdentifierExpression(identifier: "foo"),
                operatorSymbol: "?"
            ),
            member: "bar"
        ).accept(KotlinTranslator(indentLevel: 0)), "foo?.bar")

        // FIXME
//        XCTAssertEqual(try! SubscriptExpression(
//            expression: PostfixUnaryOperation(
//                operand: IdentifierExpression(identifier: "foo"),
//                operatorSymbol: "?"
//            ),
//            arguments: [IntegerLiteral(value: 0)]
//        ).accept(KotlinTranslator(indentLevel: 0)), "foo?[0]")

        // FIXME
//        XCTAssertEqual(try! FunctionCallExpression(
//            expression: PostfixUnaryOperation(
//                operand: IdentifierExpression(identifier: "foo"),
//                operatorSymbol: "?"
//            ),
//            arguments: [],
//            trailingClosure: nil
//        ).accept(KotlinTranslator(indentLevel: 0)), "foo?()")
    }
}
