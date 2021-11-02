// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPackageList",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v9),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(name: "SwiftPackageList", targets: ["SwiftPackageList"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.1")
    ],
    targets: [
        .target(name: "SwiftPackageList"),
        .executableTarget(
            name: "SwiftPackageListCommand",
            dependencies: [
                .target(name: "SwiftPackageList"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "SwiftPackageListTests",
            dependencies: ["SwiftPackageList"]),
    ]
)
