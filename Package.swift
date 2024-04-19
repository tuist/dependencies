// swift-tools-version: 5.8.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Dependencies",
    platforms: [.macOS("12.0")],
    products: [
        .library(
            name: "Dependencies",
            type: .static,
            targets: ["Dependencies"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Dependencies",
            dependencies: []
        ),
        .testTarget(
            name: "DependenciesTests",
            dependencies: [
                "Dependencies",
            ]
        ),
    ]
)
