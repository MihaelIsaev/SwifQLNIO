// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwifQLNIO",
    products: [
        .library(name: "SwifQLNIO", targets: ["SwifQLNIO"]),
        ],
    dependencies: [
        .package(url: "https://github.com/MihaelIsaev/SwifQL.git", from:"1.3.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "1.10.0"),
        ],
    targets: [
        .target(name: "SwifQLNIO", dependencies: ["NIO", "SwifQL"]),
        .testTarget(name: "SwifQLNIOTests", dependencies: ["SwifQLNIO"]),
        ],
    swiftLanguageVersions: [.v4_2]
)
