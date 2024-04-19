import ProjectDescription

let project = Project(
    name: "Dependencies",
    targets: [
        .target(
            name: "Dependencies",
            destinations: [.mac, .iPad, .iPhone, .appleTv, .appleWatch, .appleVision, .appleVisionWithiPadDesign],
            product: .staticFramework,
            bundleId: "io.tuist.Dependencies",
            deploymentTargets: .multiplatform(macOS: "14.2"),
            sources: ["Sources/Dependencies/**"],
            dependencies: []
        ),
        .target(
            name: "DependenciesTests",
            destinations: [.mac, .iPad, .iPhone, .appleTv, .appleWatch, .appleVision, .appleVisionWithiPadDesign],
            product: .unitTests,
            bundleId: "io.tuist.DependenciesTests",
            deploymentTargets: .multiplatform(macOS: "14.2"),
            infoPlist: .default,
            sources: ["Tests/DependenciesTests/**"],
            resources: [],
            dependencies: [.target(name: "Dependencies")]
        ),
    ]
)
