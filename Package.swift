// swift-tools-version:5.7
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
        .plugin(name: "SwiftPackageListJSONPlugin", targets: ["SwiftPackageListJSONPlugin"]),
        .plugin(name: "SwiftPackageListPropertyListPlugin", targets: ["SwiftPackageListPropertyListPlugin"]),
        .plugin(name: "SwiftPackageListSettingsBundlePlugin", targets: ["SwiftPackageListSettingsBundlePlugin"]),
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
            dependencies: [
                .target(name: "SwiftPackageListCore"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .plugin(
            name: "SwiftPackageListJSONPlugin",
            capability: .buildTool(),
            dependencies: [.target(name: "SwiftPackageListCommand")]
        ),
        .plugin(
            name: "SwiftPackageListPropertyListPlugin",
            capability: .buildTool(),
            dependencies: [.target(name: "SwiftPackageListCommand")]
        ),
        .plugin(
            name: "SwiftPackageListSettingsBundlePlugin",
            capability: .buildTool(),
            dependencies: [.target(name: "SwiftPackageListCommand")]
        ),
        .target(
            name: "SwiftPackageListCore",
            dependencies: ["SwiftPackageList"]
        ),
        .target(name: "SwiftPackageList"),
        .target(name: "SwiftPackageListObjc"),
        .target(
            name: "SwiftPackageListUI",
            dependencies: ["SwiftPackageList"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "SwiftPackageListCommandTests"),
        .testTarget(
            name: "SwiftPackageListCoreTests",
            dependencies: ["SwiftPackageListCore"],
            resources: [.copy("Resources")]
        ),
        .testTarget(
            name: "SwiftPackageListTests",
            dependencies: ["SwiftPackageList"],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "SwiftPackageListObjcTests",
            dependencies: ["SwiftPackageListObjc"],
            resources: [.process("Resources")]
        ),
    ]
)
