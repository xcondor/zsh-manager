// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ZshrcManager",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "ZshrcManager", targets: ["ZshrcManager"])
    ],
    dependencies: [
        .package(url: "https://github.com/kareman/SwiftShell", from: "5.1.0")
    ],
    targets: [
        .executableTarget(
            name: "ZshrcManager",
            dependencies: ["SwiftShell"],
            path: "Sources/ZshrcManager",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "ZshrcManagerTests",
            dependencies: ["ZshrcManager"],
            path: "Tests/ZshrcManagerTests"
        )
    ]
)
