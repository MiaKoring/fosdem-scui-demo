// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SCUIDemo",
    platforms: [.macOS(.v13), .iOS(.v16), .tvOS(.v16), .macCatalyst(.v16)],
    dependencies: [
        .package(
            url: "https://github.com/stackotter/swift-bundler",
            revision: "2cbe252923017306998297ee8bea817079a0eda4"
        ),
        .package(
            url: "https://github.com/stackotter/swift-cross-ui",
            branch: "main"
        ),
        .package(url: "https://github.com/miakoring/vein-scui", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "SCUIDemo",
            dependencies: [
                .product(name: "SwiftCrossUI", package: "swift-cross-ui"),
                .product(name: "DefaultBackend", package: "swift-cross-ui"),
                .product(name: "SwiftBundlerRuntime", package: "swift-bundler"),
                .product(name: "VeinSCUI", package: "vein-scui")
            ]
        )
    ]
)
