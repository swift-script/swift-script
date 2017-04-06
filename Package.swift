import PackageDescription

let package = Package(
    name: "SwiftScript",
    targets: [
        Target(name: "SwiftAST"),
        Target(name: "SwiftParse", dependencies: ["SwiftAST"]),
        Target(name: "SwiftScript", dependencies: ["SwiftParse"]),
    ],
    dependencies: [
        .Package(url: "https://github.com/koher/TryParsec.git", "0.1.1"),
    ]
)
