import ProjectDescription

let project = Project(
    name: "Context",
    targets: [
        .target(
            name: "Context",
            destinations: [.mac, .iPad, .iPhone, .appleTv, .appleWatch, .appleVision, .appleVisionWithiPadDesign],
            product: .staticFramework,
            bundleId: "io.tuist.Context",
            sources: ["Context/Sources/**"],
            dependencies: []
        ),
        .target(
            name: "ContextTests",
            destinations: [.mac, .iPad, .iPhone, .appleTv, .appleWatch, .appleVision, .appleVisionWithiPadDesign],
            product: .unitTests,
            bundleId: "io.tuist.ContextTests",
            infoPlist: .default,
            sources: ["Context/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Context")]
        ),
    ]
)
