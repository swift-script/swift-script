import XCTest
@testable import SwiftScript

class DeclarationsTests: XCTestCase {
    func testConstantDeclaration() {
        XCTAssertEqual(ConstantDeclaration(isStatic: false, name: "foo", type: TypeIdentifier­(names: ["Int"]), expression: IntegerLiteral(value: 42)).javaScript(with: 0), "const foo = 42;")

        // types
        XCTAssertEqual(ConstantDeclaration(isStatic: false, name: "foo", type: OptionalType(type: TypeIdentifier­(names: ["Int"])), expression: IntegerLiteral(value: 42)).javaScript(with: 0), "const foo = 42;")
    }
    
    func testVariabletDeclaration() {
        XCTAssertEqual(VariableDeclaration(isStatic: false, name: "foo", type: TypeIdentifier­(names: ["Int"]), expression: IntegerLiteral(value: 42)).javaScript(with: 0), "let foo = 42;")
        
        // types
        XCTAssertEqual(VariableDeclaration(isStatic: false, name: "foo", type: OptionalType(type: TypeIdentifier­(names: ["Int"])), expression: IntegerLiteral(value: 42)).javaScript(with: 0), "let foo = 42;")
    }
    
    func testTypeAliasDeclaration() {
        // Unsupported
    }
    
    func testFunctionDeclaration() {
        XCTAssertEqual(FunctionDeclaration(
            name: "foo",
            arguments: [],
            result: nil,
            hasThrows: false,
            body: []
        ).javaScript(with: 0), "function foo() {\n}")
        
        // arguments
        XCTAssertEqual(FunctionDeclaration(
            name: "foo",
            arguments: [
                (nil, "bar", TypeIdentifier­(names: ["Int"]), nil),
                (nil, "baz", TypeIdentifier­(names: ["String"]), nil),
            ],
            result: nil,
            hasThrows: false,
            body: []
        ).javaScript(with: 0), "function foo(bar, baz) {\n}")
        
        // explicit parameter names, return type, throws
        XCTAssertEqual(FunctionDeclaration(
            name: "foo",
            arguments: [
                ("bar", "x", TypeIdentifier­(names: ["Int"]), nil),
                ("baz", "y", TypeIdentifier­(names: ["String"]), nil),
                ],
            result: TypeIdentifier­(names: ["Void"]),
            hasThrows: true,
            body: []
        ).javaScript(with: 0), "function foo(x, y) {\n}")
        
        // body
        XCTAssertEqual(FunctionDeclaration(
            name: "foo",
            arguments: [
                (nil, "x", TypeIdentifier­(names: ["Int"]), nil),
                (nil, "y", TypeIdentifier­(names: ["Int"]), nil),
                ],
            result: nil,
            hasThrows: false,
            body: [
                ReturnStatement(expression: BinaryOperation(
                    leftOperand: IdentifierExpression(identifier: "x"),
                    operatorSymbol: "+",
                    rightOperand: IdentifierExpression(identifier: "y")
                ))
            ]
        ).javaScript(with: 0), "function foo(x, y) {\n    return x + y;\n}")
        
        // indentLevel = 1
        XCTAssertEqual(FunctionDeclaration(
            name: "foo",
            arguments: [
                (nil, "x", TypeIdentifier­(names: ["Int"]), nil),
                (nil, "y", TypeIdentifier­(names: ["Int"]), nil),
                ],
            result: nil,
            hasThrows: false,
            body: [
                ReturnStatement(expression: BinaryOperation(
                    leftOperand: IdentifierExpression(identifier: "x"),
                    operatorSymbol: "+",
                    rightOperand: IdentifierExpression(identifier: "y")
                ))
            ]
        ).javaScript(with: 1), "    function foo(x, y) {\n        return x + y;\n    }")
    }
    
    func testClassDeclaration­() {
        XCTAssertEqual(ClassDeclaration­(
            name: "Foo",
            superTypes: [],
            members: []
        ).javaScript(with: 0), "class Foo {\n}")
        
        // properties
        XCTAssertEqual(ClassDeclaration­(
            name: "Foo",
            superTypes: [],
            members: [
                VariableDeclaration(
                    isStatic: false,
                    name: "bar",
                    type: TypeIdentifier­(names: ["Int"]),
                    expression: nil
                ),
                ConstantDeclaration(
                    isStatic: false,
                    name: "baz",
                    type: nil,
                    expression: StringLiteral(value: "xyz")
                ),
                InitializerDeclaration­(
                    arguments: [(nil, "bar", TypeIdentifier­(names: ["Int"]), nil)],
                    isFailable: false,
                    hasThrows: false,
                    body: [
                        BinaryOperation(
                            leftOperand: ExplicitMemberExpression(
                                expression: SelfExpression(),
                                member: "bar"
                            ),
                            operatorSymbol: "=",
                            rightOperand: IntegerLiteral(value: 42)
                        )
                    ]
                ),
            ]
        ).javaScript(with: 0), "class Foo {\n    constructor(bar) {\n        self.bar = 42;\n        self.baz = \"xyz\";\n    }\n}")
        
        // methods
        XCTAssertEqual(ClassDeclaration­(
            name: "Foo",
            superTypes: [],
            members: [
                FunctionDeclaration(
                    name: "bar",
                    arguments: [],
                    result: nil,
                    hasThrows: false,
                    body: []
                )
            ]
        ).javaScript(with: 0), "class Foo {\n    bar (){\n    }\n}")
        
        // indentLevel + 1
        XCTAssertEqual(ClassDeclaration­(
            name: "Foo",
            superTypes: [],
            members: [
                VariableDeclaration(
                    isStatic: false,
                    name: "bar",
                    type: TypeIdentifier­(names: ["Int"]),
                    expression: nil
                ),
                ConstantDeclaration(
                    isStatic: false,
                    name: "baz",
                    type: nil,
                    expression: StringLiteral(value: "xyz")
                ),
                InitializerDeclaration­(
                    arguments: [(nil, "bar", TypeIdentifier­(names: ["Int"]), nil)],
                    isFailable: false,
                    hasThrows: false,
                    body: [
                        BinaryOperation(
                            leftOperand: ExplicitMemberExpression(
                                expression: SelfExpression(),
                                member: "bar"
                            ),
                            operatorSymbol: "=",
                            rightOperand: IntegerLiteral(value: 42)
                        )
                    ]
                ),
                ]
            ).javaScript(with: 1), "    class Foo {\n        constructor(bar) {\n            self.bar = 42;\n            self.baz = \"xyz\";\n        }\n    }")
    }
}
