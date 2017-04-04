import PackageDescription

let package = Package(
    name: "SwiftScript",
    targets: [
        Target(name: "SwiftScriptAST"),
        Target(name: "SwiftScriptParse", dependencies: ["SwiftScriptAST"]),
        Target(name: "SwiftScriptTranslate", dependencies: ["SwiftScriptAST"]),
        Target(name: "SwiftScript", dependencies: ["SwiftScriptParse", "SwiftScriptTranslate"]),
    ],
    dependencies: [
        .Package(url: "https://github.com/koher/TryParsec.git", "0.1.1"),
    ]
)
