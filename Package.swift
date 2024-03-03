// swift-tools-version:5.9
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
        .visionOS(.v1),
    ],
    products: [
        .executable(name: "swift-package-list", targets: ["swift-package-list"]),
        .plugin(name: "SwiftPackageListPlugin", targets: ["SwiftPackageListPlugin"]),
        .library(name: "SwiftPackageList", targets: ["SwiftPackageList"]),
        .library(name: "SwiftPackageListUI", targets: ["SwiftPackageListUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "swift-package-list",
            dependencies: [
                .target(name: "SwiftPackageListCore"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .plugin(
            name: "SwiftPackageListPlugin",
            capability: .buildTool(),
            dependencies: [.target(name: "swift-package-list")]
        ),
        .target(
            name: "SwiftPackageListCore",
            dependencies: [.target(name: "SwiftPackageList")]
        ),
        .target(
            name: "SwiftPackageList",
            resources: [.process("Resources")]
        ),
        .target(
            name: "SwiftPackageListUI",
            dependencies: [.target(name: "SwiftPackageList")],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "swift-package-list-tests"),
        .testTarget(
            name: "SwiftPackageListCoreTests",
            dependencies: [.target(name: "SwiftPackageListCore")],
            resources: [.copy("Resources")]
        ),
        .testTarget(
            name: "SwiftPackageListTests",
            dependencies: [.target(name: "SwiftPackageList")],
            resources: [.process("Resources")]
        ),
    ]
)
