// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPackageList",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_15),
        .macCatalyst(.v13),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .executable(name: "swift-package-list", targets: ["SwiftPackageListCommand"]),
        .library(name: "SwiftPackageList", targets: ["SwiftPackageList"]),
        .library(name: "SwiftPackageListObjc", type: .dynamic, targets: ["SwiftPackageListObjc"]),
        .library(name: "SwiftPackageListUI", targets: ["SwiftPackageListUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.1"),
    ],
    targets: [
        .executableTarget(
            name: "SwiftPackageListCommand",
            dependencies: ["SwiftPackageListCore"]),
        .target(
            name: "SwiftPackageListCore",
            dependencies: [
                .target(name: "SwiftPackageList"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .target(name: "SwiftPackageList"),
        .target(name: "SwiftPackageListObjc"),
        .target(
            name: "SwiftPackageListUI",
            dependencies: ["SwiftPackageList"],
            resources: [.process("Resources")]),
        .testTarget(
            name: "SwiftPackageListCoreTests",
            dependencies: ["SwiftPackageListCore"],
            resources: [.copy("Resources")]),
        .testTarget(
            name: "SwiftPackageListTests",
            dependencies: ["SwiftPackageList"],
            resources: [.process("Resources")]),
        .testTarget(
            name: "SwiftPackageListObjcTests",
            dependencies: ["SwiftPackageListObjc"],
            resources: [.process("Resources")]),
    ]
)
