// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LocalSecurityTwin",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .executable(
            name: "LocalSecurityTwin",
            targets: ["LocalSecurityTwin"]
        ),
    ],
    targets: [
        .executableTarget(
            name: "LocalSecurityTwin",
            path: "Sources/LocalSecurityTwin"
        ),
        .testTarget(
            name: "LocalSecurityTwinTests",
            dependencies: ["LocalSecurityTwin"],
            path: "Tests/LocalSecurityTwinTests"
        ),
        .testTarget(
            name: "LocalSecurityTwinE2ETests",
            dependencies: ["LocalSecurityTwin"],
            path: "Tests/LocalSecurityTwinE2ETests"
        ),
    ]
)
