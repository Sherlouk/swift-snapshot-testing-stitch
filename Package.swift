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
        .package(name: "swift-snapshot-testing",
                 url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
                 from: "1.10.0"),
        .package(name: "SnapshotTestingHEIC",
                 url: "https://github.com/alexey1312/SnapshotTestingHEIC.git",
                 from: "1.1.0"),
    ],
    targets: [
        .target(
            name: "SnapshotTestingStitch",
            dependencies: [
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                .product(name: "SnapshotTestingHEIC", package: "SnapshotTestingHEIC"),
            ]
        ),
        
        .testTarget(
            name: "SnapshotTestingStitchTests",
            dependencies: ["SnapshotTestingStitch"],
            exclude: ["__Snapshots__"]
        ),
    ]
)
