// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "MergeImage",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "MergeImage",
            targets: ["MergeImage"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "MergeImage",
            dependencies: [],
            path: "Sources"
        )
    ]
)
