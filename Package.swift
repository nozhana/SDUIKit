// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SDUIKit",
    platforms: [.macOS(.v14), .iOS(.v17), .macCatalyst(.v17)],
    products: [
        .library(name: "SDUIKit", targets: ["SDUIKit"]),
        .executable(name: "SDUIKitClient",
                    targets: ["SDUIKitClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "6.0.1"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.0"),
    ],
    targets: [
        .target(
            name: "SDUIKit",
            dependencies: ["SDUIWidgets"]
        ),
        
        .target(
            name: "SDUICore"
        ),
        
        .target(
            name: "SDUIUtilities"
        ),
        
        .macro(
            name: "SDUIMacrosInternal",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                "SDUICore",
            ]
        ),
        
        .target(name: "SDUIMacros", dependencies: ["SDUIMacrosInternal"]),
        
        .target(
            name: "SDUIWidgets",
            dependencies: ["SDUICore", "SDUIUtilities", "SDUIMacros", "Yams"]
        ),
        
        .executableTarget(name: "SDUIKitClient",
                          dependencies: ["SDUIKit"]),
    ]
)
