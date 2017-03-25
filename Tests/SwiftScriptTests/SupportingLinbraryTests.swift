import XCTest
@testable import SwiftScript

class SupportingLibraryTests: XCTestCase {
    func testJavascript() {
        let script = SupportingLibrary.javaScript(for: Set([.optionalCast]))
        XCTAssertEqual(script, "$ss = {};\n((ss) => {\n    function asq(expression, type_test) {\n      return type_test() ? expression : null;\n    }\n    ss.asq = asq;\n})($ss);")
    }
}
