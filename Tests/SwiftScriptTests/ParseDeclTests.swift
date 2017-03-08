import XCTest
@testable import SwiftScript

class ParseDeclTests: XCTestCase {
    func testDeclFunction() {
        XCTAssertTrue(parseSuccess(
            declFunction,
            "func foo(x: A = 1, x y: B) throws -> C {\n"
                + "  return foo\n"
                + "}"))
        XCTAssertTrue(parseSuccess(
            declFunction,
            "func foo(x:A=1,x y:B)throws->C{return foo}"))
        XCTAssertTrue(parseSuccess(
            declFunction,
            "static func foo() { }"))
        XCTAssertTrue(parseSuccess(
            declFunction,
            "func foo<T>(x:T) throws -> C where T == X {}"))
    }
    
    func testDeclInitializer() {
        XCTAssertTrue(parseSuccess(
            declInitializer,
            "init(x: A = 1, x y: B) throws {\n"
                + "  self.x = y\n"
                + "}"))
        XCTAssertTrue(parseSuccess(
            declInitializer,
            "init?() {}"))
        XCTAssertTrue(parseSuccess(
            declInitializer,
            "init?<T>(x: T) where T: Sequence {}"))
    }
    
    func testDeclClass() {
        XCTAssertTrue(parseSuccess(
            declClass, "class Foo {}"))
        XCTAssertTrue(parseSuccess(
            declClass, "class Foo { init() {} }"))
        XCTAssertTrue(parseSuccess(
            declClass,
            "class Foo {\n"
                + "  var x: Int = 2\n"
                + "  init () {}\n"
                + "  func foo() {}\n"
                + "}"))
        XCTAssertTrue(parseSuccess(
            declClass, "class Foo: Base {}"))
        XCTAssertTrue(parseSuccess(
            declClass, "class Foo<X>: Base where X: Foo {}"))
    }
    
    func testDeclConstant() {
        XCTAssertTrue(parseSuccess(
            declConstant, "let a = 1"))
        XCTAssertTrue(parseSuccess(
            declConstant, "let a=1"))
        XCTAssertTrue(parseSuccess(
            declConstant, "let a : Int = 1"))
        XCTAssertTrue(parseSuccess(
            declConstant, "static let foo: Int = 1"))
    }
    
    func testDeclVariable() {
        XCTAssertTrue(parseSuccess(
            declVariable, "var a = 1"))
        XCTAssertTrue(parseSuccess(
            declVariable, "var a=1"))
        XCTAssertTrue(parseSuccess(
            declVariable, "var a : Int = 1"))
        XCTAssertTrue(parseSuccess(
            declVariable, "static var foo = { (x: Int) in print(x) }"))
    }
}
