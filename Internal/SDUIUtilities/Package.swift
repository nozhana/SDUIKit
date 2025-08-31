// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SDUIUtilities",
    platforms: [.macOS(.v14), .iOS(.v17), .macCatalyst(.v17)],
    products: [
        .library(
            name: "SDUIUtilities",
            targets: ["SDUIUtilities"]),
    ],
    targets: [
        .target(
            name: "SDUIUtilities"),
    ]
)
