import XCTest
@testable import SwiftScript

class ParseExprTests: XCTestCase {
    func testExpr() {
        ParseAssertEqual(
            expr,
            "a + try! b + try? c as C is C*12 + !X",
            BinaryOperation(
                leftOperand: BinaryOperation(
                    leftOperand: BinaryOperation(
                        leftOperand: BinaryOperation(
                            leftOperand: BinaryOperation(
                                leftOperand: BinaryOperation(
                                    leftOperand: IdentifierExpression(identifier: "a"),
                                    operatorSymbol: "+",
                                    rightOperand: PrefixUnaryOperation(
                                        operatorSymbol: "try!",
                                        operand: IdentifierExpression(identifier: "b")
                                    )
                                ),
                                operatorSymbol: "+",
                                rightOperand: PrefixUnaryOperation(
                                    operatorSymbol: "try?",
                                    operand: IdentifierExpression(identifier: "c")
                                )
                            ),
                            operatorSymbol: "as",
                            rightOperand: IdentifierExpression(identifier: "C")
                        ),
                        operatorSymbol: "is",
                        rightOperand: IdentifierExpression(identifier: "C")
                    ),
                    operatorSymbol: "*",
                    rightOperand: IntegerLiteral(value: 12)
                ),
                operatorSymbol: "+",
                rightOperand: PrefixUnaryOperation(
                    operatorSymbol: "!",
                    operand: IdentifierExpression(identifier: "X")
                )
            )
        )
        ParseAssertEqual(
            expr,
            "[foo, x[12]]",
            ArrayLiteral(value: [
                IdentifierExpression(identifier: "foo"),
                SubscriptExpression(
                    expression: IdentifierExpression(identifier: "x"),
                    arguments: [
                        IntegerLiteral(value: 12),
                    ]
                )
            ])
        )
    }
    
    func testExprIdentifier() {
        ParseAssertEqual(
            expr,
            "foo",
            IdentifierExpression(identifier: "foo")
        )
        ParseAssertEqual(
            expr,
            "$12",
            IdentifierExpression(identifier: "$12")
        )
        ParseAssertEqual(
            expr,
            "foo<A, B>",
            IdentifierExpression(identifier: "foo")
        )
        XCTAssertFalse(parseSuccess(
            exprIdentifier, "self"))
        XCTAssertFalse(parseSuccess(
            exprIdentifier, "`$1`"))
    }
    
    func testExprExplicitMember() {
        ParseAssertEqual(
            expr,
            "foo.bar",
            ExplicitMemberExpression(
                expression: IdentifierExpression(identifier: "foo"),
                member: "bar"
            )
        )
        ParseAssertEqual(
            expr,
            "foo.bar<A>",
            ExplicitMemberExpression(
                expression: IdentifierExpression(identifier: "foo"),
                member: "bar"
            )
        )
    }
    
    func testExprCall() {
        ParseAssertEqual(
            expr,
            "foo(x)",
            FunctionCallExpression(
                expression: IdentifierExpression(identifier: "foo"),
                arguments: [(nil, IdentifierExpression(identifier: "x"))],
                trailingClosure: nil
            )
        )
        ParseAssertEqual(
            expr,
            "foo.bar<Int>(x: 1)",
            FunctionCallExpression(
                expression: ExplicitMemberExpression(
                    expression: IdentifierExpression(identifier: "foo"),
                    member: "bar"
                ),
                arguments: [("x", IntegerLiteral(value: 1))],
                trailingClosure: nil
            )
        )

        ParseAssertEqual(
            expr,
            "foo(x: 1) { x in }",
            FunctionCallExpression(
                expression: IdentifierExpression(identifier: "foo"),
                arguments: [("x", IntegerLiteral(value: 1))],
                trailingClosure: ClosureExpression(
                    arguments: [("x", nil)],
                    hasThrows: false,
                    result: nil,
                    statements: []
                )
            )
        )
        
        XCTAssertFalse(parseSuccess(
            expr, "foo(x y: 1)"))
    }

    func testExprTrailingClosure() {
        ParseAssertEqual(
            expr,
            "foo {}",
            FunctionCallExpression(
                expression: IdentifierExpression(identifier: "foo"),
                arguments: [],
                trailingClosure: ClosureExpression(
                    arguments: [],
                    hasThrows: false,
                    result: nil,
                    statements: []
                )
            )
        )
        ParseAssertEqual(
            expr,
            "foo.bar { x, y in (x, y) }",
            FunctionCallExpression(
                expression: ExplicitMemberExpression(
                    expression: IdentifierExpression(identifier: "foo"),
                    member: "bar"
                ),
                arguments: [],
                trailingClosure: ClosureExpression(
                    arguments: [
                        ("x", nil),
                        ("y", nil),
                    ],
                    hasThrows: false,
                    result: nil,
                    statements: [
                        ExpressionStatement(TupleExpression(elements: [
                            (nil, IdentifierExpression(identifier: "x")),
                            (nil, IdentifierExpression(identifier: "y")),
                        ]))
                    ]
                )
            )
        )
    }
    
    func testExprSubscript() {
        ParseAssertEqual(
            expr,
            "foo[x]",
            SubscriptExpression(
                expression: IdentifierExpression(identifier: "foo"),
                arguments: [
                    IdentifierExpression(identifier: "x"),
                ]
            )
        )
        ParseAssertEqual(
            expr,
            "foo.bar[1, 2]",
            SubscriptExpression(
                expression: ExplicitMemberExpression(
                    expression: IdentifierExpression(identifier: "foo"),
                    member: "bar"
                ),
                arguments: [
                    IntegerLiteral(value: 1),
                    IntegerLiteral(value: 2),
                ]
            )
        )
    }

    func testExprPostixUnary() {
        ParseAssertEqual(
            expr,
            "foo!",
            PostfixUnaryOperation(
                operand: IdentifierExpression(identifier: "foo"),
                operatorSymbol: "!"
            )
        )
        ParseAssertEqual(
            expr,
            "foo!.bar",
            ExplicitMemberExpression(
                expression:  PostfixUnaryOperation(
                    operand: IdentifierExpression(identifier: "foo"),
                    operatorSymbol: "!"
                ),
                member: "bar"
            )
        )
        ParseAssertEqual(
            expr,
            "foo?.bar",
            ExplicitMemberExpression(
                expression:  PostfixUnaryOperation(
                    operand: IdentifierExpression(identifier: "foo"),
                    operatorSymbol: "?"
                ),
                member: "bar"
            )
        )
        ParseAssertEqual(
            expr,
            "foo?()",
            FunctionCallExpression(
                expression:  PostfixUnaryOperation(
                    operand: IdentifierExpression(identifier: "foo"),
                    operatorSymbol: "?"
                ),
                arguments: [],
                trailingClosure: nil
            )
        )
        ParseAssertEqual(
            expr,
            "foo?(bar)",
            FunctionCallExpression(
                expression:  PostfixUnaryOperation(
                    operand: IdentifierExpression(identifier: "foo"),
                    operatorSymbol: "?"
                ),
                arguments: [
                    (nil, IdentifierExpression(identifier: "bar")),
                ],
                trailingClosure: nil
            )
        )
        ParseAssertEqual(
            expr,
            "foo?[bar]",
            SubscriptExpression(
                expression:  PostfixUnaryOperation(
                    operand: IdentifierExpression(identifier: "foo"),
                    operatorSymbol: "?"
                ),
                arguments: [
                    IdentifierExpression(identifier: "bar"),
                ]
            )
        )
    }
    
    func testExprParen() {
        ParseAssertEqual(
            expr,
            "(x)",
            ParenthesizedExpression(expression: IdentifierExpression(identifier: "x"))
        )
        ParseAssertEqual(
            expr,
            "(foo.bar())",
            ParenthesizedExpression(
                expression: FunctionCallExpression(
                    expression: ExplicitMemberExpression(
                        expression: IdentifierExpression(identifier: "foo"),
                        member: "bar"
                    ),
                    arguments: [],
                    trailingClosure: nil
                )
            )
        )
    }
    
    func testExprTuple() {
        ParseAssertEqual(
            expr,
            "(x, 1)",
            TupleExpression(elements: [
                (nil, IdentifierExpression(identifier: "x")),
                (nil, IntegerLiteral(value: 1)),
            ])
        )
        ParseAssertEqual(
            expr,
            "(foo: 1, bar: 2)",
            TupleExpression(elements: [
                ("foo", IntegerLiteral(value: 1)),
                ("bar", IntegerLiteral(value: 2)),
            ])
        )
    }
    
    func testExprImplicitMember() {
        XCTAssertTrue(parseSuccess(
            exprImplicitMember, ".foo"))
        XCTAssertTrue(parseSuccess(
            expr, ".foo(x: 1)"))
    }
    
    func testExprWildcard() {
        ParseAssertEqual(
            expr,
            "_",
            WildcardExpression()
        )
        ParseAssertEqual(
            expr,
            "_.foo",
            ExplicitMemberExpression(
                expression: WildcardExpression(),
                member: "foo"
            )
        )
    }
    
    func testExprSelf() {
        ParseAssertEqual(
            expr,
            "self",
            SelfExpression()
        )
        ParseAssertEqual(
            expr,
            "self.foo()",
            FunctionCallExpression(
                expression: ExplicitMemberExpression(
                    expression: SelfExpression(),
                    member: "foo"),
                arguments: [],
                trailingClosure: nil
            )
        )
    }
    
    func testExprSuper() {
        ParseAssertEqual(
            expr,
            "super",
            SuperclassExpression()
        )
        ParseAssertEqual(
            expr,
            "super.foo()",
            FunctionCallExpression(
                expression: ExplicitMemberExpression(
                    expression: SuperclassExpression(),
                    member: "foo"),
                arguments: [],
                trailingClosure: nil
            )
        )
    }

    func testExprClosure() {
        ParseAssertEqual(
            expr,
            "{}",
            ClosureExpression(arguments: [], hasThrows: false, result: nil, statements: [])
        )
        ParseAssertEqual(
            expr,
            "{ _ in x }",
            ClosureExpression(arguments: [("_", nil)], hasThrows: false, result: nil, statements: [
                ExpressionStatement(IdentifierExpression(identifier: "x")),
            ])
        )
        ParseAssertEqual(
            expr,
            "{ x in }",
            ClosureExpression(arguments: [("x", nil)], hasThrows: false, result: nil, statements: [])
        )
        ParseAssertEqual(
            expr,
            "{ x, y in }",
            ClosureExpression(arguments: [("x", nil), ("y", nil)], hasThrows: false, result: nil, statements: [])
        )
        ParseAssertEqual(
            expr,
            "{ (x, y) in }",
            ClosureExpression(arguments: [("x", nil), ("y", nil)], hasThrows: false, result: nil, statements: [])
        )
        ParseAssertEqual(
            expr,
            "{ (x: Int, y: Int) in }",
            ClosureExpression(
                arguments: [
                    ("x", TypeIdentifier(names: ["Int"])),
                    ("y", TypeIdentifier(names: ["Int"])),
                ],
                hasThrows: false,
                result: nil,
                statements: []
            )
        )
        ParseAssertEqual(
            expr,
            "{ (x: Int, y: Int) -> Int in }",
            ClosureExpression(
                arguments: [
                    ("x", TypeIdentifier(names: ["Int"])),
                    ("y", TypeIdentifier(names: ["Int"])),
                    ],
                hasThrows: false,
                result: TypeIdentifier(names: ["Int"]),
                statements: []
            )
        )
        ParseAssertEqual(
            expr,
            "{ (x: Int, y: Int) throws -> Int in }",
            ClosureExpression(
                arguments: [
                    ("x", TypeIdentifier(names: ["Int"])),
                    ("y", TypeIdentifier(names: ["Int"])),
                ],
                hasThrows: true,
                result: TypeIdentifier(names: ["Int"]),
                statements: []
            )
        )
        ParseAssertEqual(
            expr,
            "{ $0.foo[12] }",
            ClosureExpression(
                arguments: [],
                hasThrows: false,
                result: nil,
                statements: [
                    ExpressionStatement(SubscriptExpression(
                        expression: ExplicitMemberExpression(
                            expression: IdentifierExpression(identifier: "$0"),
                            member: "foo"
                        ),
                        arguments: [
                            IntegerLiteral(value: 12),
                        ]
                    )),
                ]
            )
        )
        ParseAssertEqual(
            expr,
            "{ let x = 1\n return $0 + 12\n}",
            ClosureExpression(
                arguments: [],
                hasThrows: false,
                result: nil,
                statements: [
                    DeclarationStatement(ConstantDeclaration(
                        isStatic: false,
                        name: "x",
                        type: nil,
                        expression: IntegerLiteral(value: 1)
                    )),
                    ReturnStatement(
                        expression: BinaryOperation(
                            leftOperand: IdentifierExpression(identifier: "$0"),
                            operatorSymbol: "+",
                            rightOperand: IntegerLiteral(value: 12)
                        )
                    ),
                ]
            )
        )
    }

    func testExprAssign() {
        ParseAssertEqual(
            expr,
            "self.x = 1",
            BinaryOperation(
                leftOperand: ExplicitMemberExpression(
                    expression: SelfExpression(),
                    member: "x"
                ),
                operatorSymbol: "=",
                rightOperand: IntegerLiteral(value: 1)
            )
        )
    }
}
