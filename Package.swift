// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SnapshotTestingStitch",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "SnapshotTestingStitch",
            targets: ["SnapshotTestingStitch"]
        ),
    ],
    dependencies: [
        .package(name: "SnapshotTesting",
                 url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.8.0"),
    ],
    targets: [
        .target(
            name: "SnapshotTestingStitch",
            dependencies: [
                .product(name: "SnapshotTesting", package: "SnapshotTesting"),
            ]
        ),
        
        .testTarget(
            name: "SnapshotTestingStitchTests",
            dependencies: ["SnapshotTestingStitch"],
            exclude: ["__Snapshots__"]
        ),
    ]
)
