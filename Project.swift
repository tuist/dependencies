import ProjectDescription

let project = Project(
    name: "Context",
    targets: [
        .target(
            name: "Context",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.Context",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                ]
            ),
            sources: ["Context/Sources/**"],
            resources: ["Context/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "ContextTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.ContextTests",
            infoPlist: .default,
            sources: ["Context/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Context")]
        ),
    ]
)
