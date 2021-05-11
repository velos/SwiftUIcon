// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "SwiftUIcon",
    products: [
        .library(
            name: "SwiftUIcon",
            targets: ["SwiftUIcon"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftUIcon",
            dependencies: [],
            path: "Icon"),
    ]
)
