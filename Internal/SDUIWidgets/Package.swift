// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SDUIWidgets",
    platforms: [.macOS(.v14), .iOS(.v17), .macCatalyst(.v17)],
    products: [
        .library(
            name: "SDUIWidgets",
            targets: ["SDUIWidgets"]),
    ],
    dependencies: [
        .package(path: "../SDUIUtilities"),
    ],
    targets: [
        .target(
            name: "SDUIWidgets", dependencies: ["SDUIUtilities"],
            swiftSettings: [.enableExperimentalFeature("BareSlashRegexLiterals")]),
    ]
)
