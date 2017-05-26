import XCTest
@testable import SwiftKotlin

class SwiftScriptTests: XCTestCase {
    let swiftCode = [
    "let x = 1",
    "var x = 2",

    "let x = {",
    "   $0 + 1",
    "}",

    "func f(_ x: Double, y: String) -> MyStruct {",
    "   return MyStruct(x, y)",
    "}",

    "protocol Hello: A, B {",
    "  var foo: String { get }",
    "  var bar: String { get set }",
    "}",

    "protocol Hello: A, B {",
    "var foo: String { get }",
    "var bar: String { get set }",
    "}",

    "struct Hello: A, B {",
    "  var x: Int = 3",
    "  let y: String",
    "  func foo() -> String {}",
    "}",

    "class Hello: A, B {",
    "  var x: Int",
    "  init(x: Int) {",
    "    self.x = x",
    "    super.init(value: 3)",
    "  }",
    "}",

    "class A {",
    "  init(param1: Int, param2: Int) { }",
    "  func method(param1: Int, param2: Int) { }",
    "}",

    "if number == 3 {}",
    "if (number == 3) {}",
    "if number == nil {}",
    "if item is Movie {}",
    "if method() {}",
    "if let v = opt() {}",
    "if let v = opt { v + 1 }",
    "if let v = opt {\nv + 1\n}",
    "if let v = opt {\nv + 1\nv + 1\n}",

    "if numbers.flatMap({ $0 % 2}).count == 1 {}",

    "for current in someObjects {}",

    "while condition {}",

    "guard number == 3 else { return }",
    "guard value() >= 3 else { return }",
    "guard condition else { return }",
    "guard !condition else { return }",

    "guard let number = number else { return }",

    "var array: [String]?",
    //    "var array: Promise<[String]>?" // TODO
    //    "var array: [Promise<[String]>]",

    "var array = [\"1\", \"2\"]",    // TODO: convert to `arrayOf(\"1\", \"2\")`

    "var map: [Int: String]?",

    "var map = [1: \"a\", 2: \"b\"]",   // TODO: convert to `mapOf(1 to \"a\", 2 to \"b\")`

    "restaurantService.findRestaurant(restaurantId: restaurant.id, param: param)",
    "NetworkRequestServiceTask(networkSession: networkSession, endpoint: \"restaurants\")",

    "service.find(country: \"US\", page: page).onCompletion { (result: RestaurantSearch?) in }",

    "func greet(_ name: String, _ day: String) {}",  // TODO(?): omitted arg label
    "func greet(aName name: String = \"value\", day: String, other value: Int) {}",

    "func method(param: String) -> Bool {}",
    "class A {\n\tfunc method2()\n\t->Bool\n{}\n}",

    "var nextPage = (stateValue.lastPage ?? 0) + 1",
    
    "for i in 1...3 {}",
    
    "var string = \"name: \\(name1), age = \\(age1 + 3)\""
        ].joined(separator: "\n")

    func testExample() {
        print(try! transpile(swiftCode))
    }

    static var allTests : [(String, (SwiftScriptTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}

