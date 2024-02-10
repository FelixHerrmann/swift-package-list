import ProjectDescription

let project = Project(
    name: "Tuist",
    organizationName: "Test Inc.",
    packages: [
        .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.0.0")),
    ],
    targets: [
        .target(
            name: "Tuist",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.Tuist",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                ]
            ),
            sources: ["Tuist/Sources/**"],
            resources: ["Tuist/Resources/**"],
            dependencies: [
                .package(product: "Alamofire"),
            ]
        ),
        .target(
            name: "TuistTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.TuistTests",
            infoPlist: .default,
            sources: ["Tuist/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Tuist")]
        ),
    ]
)
