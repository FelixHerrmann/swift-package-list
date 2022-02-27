// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPackageList",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v9),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(name: "SwiftPackageList", targets: ["SwiftPackageList"]),
        .library(name: "SwiftPackageListUI", targets: ["SwiftPackageListUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.1")
    ],
    targets: [
        .target(name: "SwiftPackageList"),
        .target(
            name: "SwiftPackageListUI",
            dependencies: ["SwiftPackageList"],
            resources: [.process("Resources")]),
        .executableTarget(
            name: "SwiftPackageListCommand",
            dependencies: [
                .target(name: "SwiftPackageList"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
    ]
)
