import XCTest
@testable import SwiftScript

class DeclarationsTests: XCTestCase {
    func testConstantDeclaration() {
        XCTAssertEqual(try! ConstantDeclaration(isStatic: false, name: "foo", type: TypeIdentifier(names: ["Int"]), expression: IntegerLiteral(value: 42)).accept(JavaScriptTranslator(indentLevel: 0)), "const foo = 42;\n")

        // types
        XCTAssertEqual(try! ConstantDeclaration(isStatic: false, name: "foo", type: OptionalType(type: TypeIdentifier(names: ["Int"])), expression: IntegerLiteral(value: 42)).accept(JavaScriptTranslator(indentLevel: 0)), "const foo = 42;\n")
    }
    
    func testVariabletDeclaration() {
        XCTAssertEqual(try! VariableDeclaration(isStatic: false, name: "foo", type: TypeIdentifier(names: ["Int"]), expression: IntegerLiteral(value: 42)).accept(JavaScriptTranslator(indentLevel: 0)), "let foo = 42;\n")
        
        // types
        XCTAssertEqual(try! VariableDeclaration(isStatic: false, name: "foo", type: OptionalType(type: TypeIdentifier(names: ["Int"])), expression: IntegerLiteral(value: 42)).accept(JavaScriptTranslator(indentLevel: 0)), "let foo = 42;\n")
    }
    
    func testTypeAliasDeclaration() {
        // Unsupported
    }
    
    func testFunctionDeclaration() {
        XCTAssertEqual(try! FunctionDeclaration(
            isStatic: false,
            name: "foo",
            arguments: [],
            result: nil,
            hasThrows: false,
            body: []
        ).accept(JavaScriptTranslator(indentLevel: 0)), "function foo() {\n}\n")

        // static
        XCTAssertEqual(try! FunctionDeclaration(
            isStatic: true,
            name: "foo",
            arguments: [],
            result: nil,
            hasThrows: false,
            body: []
            ).accept(JavaScriptTranslator(indentLevel: 0)), "static function foo() {\n}\n")

        // arguments
        XCTAssertEqual(try! FunctionDeclaration(
            isStatic: false,
            name: "foo",
            arguments: [
                Parameter(
                    externalParameterName: nil,
                    localParameterName: "bar",
                    type: TypeIdentifier(names: ["Int"]),
                    defaultArgument: nil
                ),
                Parameter(
                    externalParameterName: nil,
                    localParameterName: "baz",
                    type: TypeIdentifier(names: ["String"]),
                    defaultArgument: nil
                ),
            ],
            result: nil,
            hasThrows: false,
            body: []
        ).accept(JavaScriptTranslator(indentLevel: 0)), "function foo(bar, baz) {\n}\n")
        
        // explicit parameter names, return type, throws
        XCTAssertEqual(try! FunctionDeclaration(
            isStatic: false,
            name: "foo",
            arguments: [
                Parameter(
                    externalParameterName: "bar",
                    localParameterName: "x",
                    type: TypeIdentifier(names: ["Int"]),
                    defaultArgument: nil
                ),
                Parameter(
                    externalParameterName: "baz",
                    localParameterName: "y",
                    type: TypeIdentifier(names: ["String"]),
                    defaultArgument: nil
                ),
            ],
            result: TypeIdentifier(names: ["Void"]),
            hasThrows: true,
            body: []
        ).accept(JavaScriptTranslator(indentLevel: 0)), "function foo(x, y) {\n}\n")
        
        // body
        XCTAssertEqual(try! FunctionDeclaration(
            isStatic: false,
            name: "foo",
            arguments: [
                Parameter(
                    externalParameterName: nil,
                    localParameterName: "x",
                    type: TypeIdentifier(names: ["Int"]),
                    defaultArgument: nil
                ),
                Parameter(
                    externalParameterName: nil,
                    localParameterName: "y",
                    type: TypeIdentifier(names: ["Int"]),
                    defaultArgument: nil
                ),
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
        ).accept(JavaScriptTranslator(indentLevel: 0)), "function foo(x, y) {\n    return x + y;\n}\n")
        
        // indentLevel = 1
        XCTAssertEqual(try! FunctionDeclaration(
            isStatic: false,
            name: "foo",
            arguments: [
                Parameter(
                    externalParameterName: nil,
                    localParameterName: "x",
                    type: TypeIdentifier(names: ["Int"]),
                    defaultArgument: nil
                ),
                Parameter(
                    externalParameterName: nil,
                    localParameterName: "y",
                    type: TypeIdentifier(names: ["Int"]),
                    defaultArgument: nil
                ),
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
        ).accept(JavaScriptTranslator(indentLevel: 1)), "    function foo(x, y) {\n        return x + y;\n    }\n")
    }
    
    func testClassDeclaration() {
        XCTAssertEqual(try! ClassDeclaration(
            name: "Foo",
            superTypes: [],
            members: []
        ).accept(JavaScriptTranslator(indentLevel: 0)), "class Foo {\n}\n")
        
        // properties
        XCTAssertEqual(try! ClassDeclaration(
            name: "Foo",
            superTypes: [],
            members: [
                VariableDeclaration(
                    isStatic: false,
                    name: "bar",
                    type: TypeIdentifier(names: ["Int"]),
                    expression: nil
                ),
                ConstantDeclaration(
                    isStatic: false,
                    name: "baz",
                    type: nil,
                    expression: StringLiteral(value: "xyz")
                ),
                InitializerDeclaration(
                    arguments: [
                        Parameter(
                            externalParameterName: nil,
                            localParameterName: "bar",
                            type: TypeIdentifier(names: ["Int"]),
                            defaultArgument: nil
                        ),
                    ],
                    isFailable: false,
                    hasThrows: false,
                    body: [
                        ExpressionStatement(BinaryOperation(
                            leftOperand: ExplicitMemberExpression(
                                expression: SelfExpression(),
                                member: "bar"
                            ),
                            operatorSymbol: "=",
                            rightOperand: IntegerLiteral(value: 42)
                        ))
                    ]
                ),
            ]
        ).accept(JavaScriptTranslator(indentLevel: 0)), "class Foo {\n    constructor(bar) {\n        this.bar = 42;\n        this.baz = \"xyz\";\n    }\n}\n")
        
        // methods
        XCTAssertEqual(try! ClassDeclaration(
            name: "Foo",
            superTypes: [],
            members: [
                FunctionDeclaration(
                    isStatic: false,
                    name: "bar",
                    arguments: [],
                    result: nil,
                    hasThrows: false,
                    body: []
                )
            ]
        ).accept(JavaScriptTranslator(indentLevel: 0)), "class Foo {\n    bar() {\n    }\n}\n")
        
        // indentLevel + 1
        XCTAssertEqual(try! ClassDeclaration(
            name: "Foo",
            superTypes: [],
            members: [
                VariableDeclaration(
                    isStatic: false,
                    name: "bar",
                    type: TypeIdentifier(names: ["Int"]),
                    expression: nil
                ),
                ConstantDeclaration(
                    isStatic: false,
                    name: "baz",
                    type: nil,
                    expression: StringLiteral(value: "xyz")
                ),
                InitializerDeclaration(
                    arguments: [
                        Parameter(
                            externalParameterName: nil,
                            localParameterName: "bar",
                            type: TypeIdentifier(names: ["Int"]),
                            defaultArgument: nil
                        ),
                    ],
                    isFailable: false,
                    hasThrows: false,
                    body: [
                        ExpressionStatement(BinaryOperation(
                            leftOperand: ExplicitMemberExpression(
                                expression: SelfExpression(),
                                member: "bar"
                            ),
                            operatorSymbol: "=",
                            rightOperand: IntegerLiteral(value: 42)
                        ))
                    ]
                ),
                ]
            ).accept(JavaScriptTranslator(indentLevel: 1)), "    class Foo {\n        constructor(bar) {\n            this.bar = 42;\n            this.baz = \"xyz\";\n        }\n    }\n")
    }
    
    func testInitializerDeclaration() {
        XCTAssertEqual(try! InitializerDeclaration(
            arguments: [],
            isFailable: false,
            hasThrows: false,
            body: [
                ExpressionStatement(BinaryOperation(
                    leftOperand: ExplicitMemberExpression(expression: SelfExpression(), member: "foo"),
                    operatorSymbol: "=",
                    rightOperand: IntegerLiteral(value: 42)
                ))
            ]
        ).accept(JavaScriptTranslator(indentLevel: 0)), "constructor() {\n    this.foo = 42;\n}\n")
        
        // arguments
        XCTAssertEqual(try! InitializerDeclaration(
            arguments: [
                Parameter(
                    externalParameterName: nil,
                    localParameterName: "bar",
                    type: TypeIdentifier(names: ["Int"]),
                    defaultArgument: nil
                ),
                Parameter(
                    externalParameterName: nil,
                    localParameterName: "baz",
                    type: TypeIdentifier(names: ["String"]),
                    defaultArgument: nil
                ),
            ],
            isFailable: false,
            hasThrows: false,
            body: [
                ExpressionStatement(BinaryOperation(
                    leftOperand: ExplicitMemberExpression(expression: SelfExpression(), member: "foo"),
                    operatorSymbol: "=",
                    rightOperand: BinaryOperation(
                        leftOperand: IdentifierExpression(identifier: "bar"),
                        operatorSymbol: "+",
                        rightOperand: IdentifierExpression(identifier: "baz")
                    )
                ))
            ]
        ).accept(JavaScriptTranslator(indentLevel: 0)), "constructor(bar, baz) {\n    this.foo = bar + baz;\n}\n")
        
        // indent
        XCTAssertEqual(try! InitializerDeclaration(
            arguments: [],
            isFailable: false,
            hasThrows: false,
            body: [
                ExpressionStatement(BinaryOperation(
                    leftOperand: ExplicitMemberExpression(expression: SelfExpression(), member: "foo"),
                    operatorSymbol: "=",
                    rightOperand: IntegerLiteral(value: 42)
                ))
            ]
        ).accept(JavaScriptTranslator(indentLevel: 1)), "    constructor() {\n        this.foo = 42;\n    }\n")
    }
}
