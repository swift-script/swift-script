import XCTest
import SwiftScriptAST
@testable import SwiftScriptTranslate

class SupportingLibraryTests: XCTestCase {
    func testJavascript() {
        let script = SupportingLibrary.javaScript(for: Set([.optionalCast]))
        XCTAssertEqual(script, "$ss = {};\n((ns) => {\n    function asq(expression, type_test) {\n        return type_test() ? expression : null;\n    }\n    ns.asq = asq;\n})($ss);")
    }
}
