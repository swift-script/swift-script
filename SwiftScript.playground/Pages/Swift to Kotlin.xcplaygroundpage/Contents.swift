//: # Swift to Kotlin

// Test cases are from:
// https://github.com/angelolloqui/SwiftKotlin

import SwiftAST
import SwiftParse
import SwiftKotlin

var swiftCode = [

    "let numbers: [Int] = [2, 3, 5]",
    "for number in numbers {",
    "  print(number)",
    "}",
    "let squared = numbers.map { $0  * $0 }",

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

    "var string = \"name: \\(name)\"",
    "var string = \"full name: \\(name) \\(lastName)\"",
    "var string = \"name: \\(name ?? lastName)\"",
    "var string = \"name: \\(user?.name ?? (\"-\" + lastName))\""

    //----------------------------------------
    // TODOs
    //----------------------------------------
//    "//Some comment"

//    "var anyObject: AnyObject? = nil" +
//    "var any: Any? = nil"
//    TODO: Convert to "var anyObject: Object? = nil" + "var any: Object? = nil"

//    "if let name = formatter.next(fromIndex: firstTokenIndex, matching: { $0.type == .symbol }, extra: true) {}"

//    "if !object.condition() {}"

//    "if case .success(let res) = self {}"

//    "guard let result = some.method()," +
//        "let param = result.number()," +
//        "param > 1 else { return }"

//    "switch nb {" +
//        "case 0...7, 8, 9: print(\"single digit\")" +
//        "case 10: print(\"double digits\")" +
//        "case 11...99: print(\"double digits\")" +
//        "default: print(\"three or more digits\")" +
//    "}"

//    "extension Double {" +
//        "\tvar km: Double { return self * 1000.0 }" +
//        "\tvar m: Double { return self }" +
//    "}"
//    "extension Double {" +
//        "\tfunc toKm() -> Double { return self * 1000.0 }" +
//        "\tfunc toMeter() -> Double { return self }" +
//    "}"
//    "extension Double {" +
//        "\tstatic func toKm() -> Double { return self * 1000.0 }" +
//        "\tstatic var m: Double { return self }" +
//    "}"

//    let swift =
//        "if let number = some.method()," +
//        "  let param = object.itemAt(number) {}"
//    let kotlin =
//        "let number = some.method()" +
//        "let param = object.itemAt(number)" +
//        "if (number != null &&\n  param != null) {}"

//    "public convenience init() {}", // TODO: "public constructor() {}"
//    "required public init() {}",    // TODO: "public constructor() {}"
//    "required convenience init() {}", // TODO: "constructor() {}"

//    "func findRestaurant(restaurantId: Int) -> ServiceTask<Restaurant> {" +
//        " return NetworkRequestServiceTask<Restaurant>(" +
//        " networkSession: networkSession," +
//        " endpoint: \"restaurants/\")" +
//    "}"

//    "var b, c, d: Int"

//    "extension Transformer where Self: KeywordResplacementTransformer {}",
//    "extension KeywordResplacementTransformer: Transformer {}",

//    "func method(param: String) -> () {}"   // TODO: `()` as `Void`

//    "private func funcTest(){}",
//    "override func afunc (){}"

//    "var stateObservable: Observable<RestaurantsListState> { return state.asObservable() }" // TODO: get/set

    // TODO: shared to lateinit

//    "class A {",
//    "  public static var myBool = true",
//    "}"

]

let swift = swiftCode.joined(separator: "\n")

do {
    let js = try transpile(swift)
    print(js)
}
catch {
    print("error = \(error)")
}

