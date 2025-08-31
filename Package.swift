// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SDUIKit",
    platforms: [.macOS(.v14), .iOS(.v17), .macCatalyst(.v17)],
    products: [
        .library(
            name: "SDUIKit",
            targets: ["SDUIKit"]),
        .executable(name: "SDUIKitClient",
                    targets: ["SDUIKitClient"]),
    ],
    dependencies: [
        .package(path: "Internal/SDUICore"),
        .package(path: "Internal/SDUIWidgets"),
        .package(path: "Internal/SDUIMacros"),
    ],
    targets: [
        .target(
            name: "SDUIKit", dependencies: ["SDUICore", "SDUIWidgets", "SDUIMacros"]),
        .executableTarget(name: "SDUIKitClient",
                          dependencies: ["SDUICore", "SDUIWidgets", "SDUIMacros"]),
    ]
)
