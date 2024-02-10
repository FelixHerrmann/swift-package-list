import ProjectDescription

let project = Project(
    name: "TuistDependencies",
    organizationName: "Test Inc.",
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
                .external(name: "Alamofire"),
            ]
        ),
    ]
)
