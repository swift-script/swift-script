import PackageDescription

let package = Package(
    name: "SwiftScript",
    dependencies: [
        .Package(url: "https://github.com/koher/TryParsec.git", "0.1.1"),
    ]
)
