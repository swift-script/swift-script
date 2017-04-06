import XCTest
import SwiftAST
@testable import SwiftParse

class ParseDeclTests: XCTestCase {
    func testDeclFunction() {
        ParseAssertEqual(
            decl,
            "func foo(x: A = 1, x y: B) throws -> C {\n"
                + "  return foo\n"
                + "}",
            FunctionDeclaration(isStatic: false,
                name: "foo",
                arguments: [
                    Parameter(
                        externalParameterName: nil,
                        localParameterName: "x",
                        type: TypeIdentifier(names: ["A"]),
                        defaultArgument: IntegerLiteral(value: 1)
                    ),
                    Parameter(
                        externalParameterName: "x",
                        localParameterName: "y",
                        type: TypeIdentifier(names: ["B"]),
                        defaultArgument: nil
                    ),
                ],
                result: TypeIdentifier(names: ["C"]),
                hasThrows: true,
                body: [
                    ReturnStatement(
                        expression: IdentifierExpression(identifier: "foo")
                    ),
                ]
            )
        )
        
        ParseAssertEqual(
            decl,
            "func foo(x:A=1,x y:B)throws->C{return foo}",
            FunctionDeclaration(
                isStatic: false,
                name: "foo",
                arguments: [
                    Parameter(
                        externalParameterName: nil,
                        localParameterName: "x",
                        type: TypeIdentifier(names: ["A"]),
                        defaultArgument: IntegerLiteral(value: 1)
                    ),
                    Parameter(
                        externalParameterName: "x",
                        localParameterName: "y",
                        type: TypeIdentifier(names: ["B"]),
                        defaultArgument: nil
                    ),
                ],
                result: TypeIdentifier(names: ["C"]),
                hasThrows: true,
                body: [
                    ReturnStatement(
                        expression: IdentifierExpression(identifier: "foo")
                    ),
                ]
            )
        )

        ParseAssertEqual(
            decl,
            "static func foo() { }",
            FunctionDeclaration(
                isStatic: true,
                name: "foo",
                arguments: [],
                result: nil,
                hasThrows: false,
                body: []
            )
        )
        
        ParseAssertEqual(
            decl,
            "func foo<T>(x:T) throws -> C where T == X {}",
            FunctionDeclaration(
                isStatic: false,
                name: "foo",
                arguments: [
                    Parameter(
                        externalParameterName: nil,
                        localParameterName: "x",
                        type: TypeIdentifier(names: ["T"]),
                        defaultArgument: nil
                    ),
                ],
                result: TypeIdentifier(names: ["C"]),
                hasThrows: true,
                body: []
            )
        )
    }
    
    func testDeclInitializer() {
        ParseAssertEqual(
            decl,
            "init(x: A = 1, x y: B) throws {\n"
                + "  self.x = y\n"
                + "}",
            InitializerDeclaration(
                arguments: [
                    Parameter(
                        externalParameterName: nil,
                        localParameterName: "x",
                        type: TypeIdentifier(names: ["A"]),
                        defaultArgument: IntegerLiteral(value: 1)
                    ),
                    Parameter(
                        externalParameterName: "x",
                        localParameterName: "y",
                        type: TypeIdentifier(names: ["B"]),
                        defaultArgument: nil
                    ),
                ],
                isFailable: false,
                hasThrows: true,
                body: [
                    ExpressionStatement(BinaryOperation(
                        leftOperand: ExplicitMemberExpression(expression: SelfExpression(), member: "x"),
                        operatorSymbol: "=",
                        rightOperand: IdentifierExpression(identifier: "y")
                    ))
                ]
            )
        )
        ParseAssertEqual(
            decl,
            "init?() {}",
            InitializerDeclaration(
                arguments: [],
                isFailable: true,
                hasThrows: false,
                body: []
            )
        )
        ParseAssertEqual(
            decl,
            "init?<T>(x: T) where T: Sequence {}",
            InitializerDeclaration(
                arguments: [
                    Parameter(
                        externalParameterName: nil,
                        localParameterName: "x",
                        type: TypeIdentifier(names: ["T"]),
                        defaultArgument: nil
                    ),
                ],
                isFailable: true,
                hasThrows: false,
                body: []
            )
        )
    }
    
    func testDeclClass() {
        ParseAssertEqual(
            decl,
            "class Foo {}",
            ClassDeclaration(name: "Foo", superTypes: [], members: [])
        )
        ParseAssertEqual(
            decl,
            "class Foo { init() {} }",
            ClassDeclaration(
                name: "Foo",
                superTypes: [],
                members: [
                    InitializerDeclaration(
                        arguments: [],
                        isFailable: false,
                        hasThrows: false,
                        body: []
                    )
                ]
            )
        )
        ParseAssertEqual(
            decl,
            "class Foo {\n"
                + "  var x: Int = 2\n"
                + "  init () {}\n"
                + "  func foo() {}\n"
                + "}",
            ClassDeclaration(
                name: "Foo",
                superTypes: [],
                members: [
                    VariableDeclaration(
                        isStatic: false,
                        name: "x",
                        type: TypeIdentifier(names: ["Int"]),
                        expression: IntegerLiteral(value: 2)
                    ),
                    InitializerDeclaration(
                        arguments: [],
                        isFailable: false,
                        hasThrows: false,
                        body: []
                    ),
                    FunctionDeclaration(
                        isStatic: false,
                        name: "foo",
                        arguments: [],
                        result: nil,
                        hasThrows: false,
                        body: []
                    ),
                ]
            )
        )
        ParseAssertEqual(
            decl,
            "class Foo: Base {}",
            ClassDeclaration(
                name: "Foo",
                superTypes: [
                    TypeIdentifier(names: ["Base"]),
                ],
                members: []
            )
        )
        ParseAssertEqual(
            decl,
            "class Foo<X>: Base where X: Foo {}",
            ClassDeclaration(
                name: "Foo",
                superTypes: [
                    TypeIdentifier(names: ["Base"]),
                    ],
                members: []
            )
        )
    }
    
    func testDeclConstant() {
        ParseAssertEqual(
            decl,
            "let a = 1",
            ConstantDeclaration(
                isStatic: false,
                name: "a",
                type: nil,
                expression: IntegerLiteral(value: 1)
            )
        )
        ParseAssertEqual(
            decl,
            "let a=1",
            ConstantDeclaration(
                isStatic: false,
                name: "a",
                type: nil,
                expression: IntegerLiteral(value: 1)
            )
        )
        ParseAssertEqual(
            decl,
            "let a : Int = 1",
            ConstantDeclaration(
                isStatic: false,
                name: "a",
                type: TypeIdentifier(names: ["Int"]),
                expression: IntegerLiteral(value: 1)
            )
        )
        ParseAssertEqual(
            decl,
            "static let foo: Int = 1",
            ConstantDeclaration(
                isStatic: true,
                name: "foo",
                type: TypeIdentifier(names: ["Int"]),
                expression: IntegerLiteral(value: 1)
            )
        )
    }
    
    func testDeclVariable() {
        ParseAssertEqual(
            decl,
            "var a = 1",
            VariableDeclaration(
                isStatic: false,
                name: "a",
                type: nil,
                expression: IntegerLiteral(value: 1)
            )
        )
        ParseAssertEqual(
            decl,
            "var a=1",
            VariableDeclaration(
                isStatic: false,
                name: "a",
                type: nil,
                expression: IntegerLiteral(value: 1)
            )
        )
        ParseAssertEqual(
            decl,
            "var a : Int = 1",
            VariableDeclaration(
                isStatic: false,
                name: "a",
                type: TypeIdentifier(names: ["Int"]),
                expression: IntegerLiteral(value: 1)
            )
        )
        ParseAssertEqual(
            decl,
            "static var foo = { (x: Int) in print(x) }",
            VariableDeclaration(
                isStatic: true,
                name: "foo",
                type: nil,
                expression: ClosureExpression(
                    arguments: [
                        ("x", TypeIdentifier(names: ["Int"]))
                    ],
                    hasThrows: false,
                    result: nil,
                    statements: [
                        ExpressionStatement(FunctionCallExpression(
                            expression: IdentifierExpression(identifier: "print"),
                            arguments: [
                                (nil, IdentifierExpression(identifier: "x"))
                            ],
                            trailingClosure: nil
                        )),
                    ]
                )
            )
        )
    }
}
