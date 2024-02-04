import ProjectDescription

let project = Project(
    name: "Tuist",
    organizationName: "Test Inc.",
    packages: [
        .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.0.0")),
    ],
    targets: [
        Target(
            name: "App",
            destinations: .iOS,
            product: .app,
            bundleId: "com.test.tuist",
            deploymentTargets: .iOS("14.0.0"),
            infoPlist: .default,
            sources: ["Targets/App/Sources/**"],
            dependencies: [
                .package(product: "Alamofire"),
            ]
        ),
    ]
)
