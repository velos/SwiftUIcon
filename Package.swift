// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftUIcon",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "SwiftUIcon", targets: ["SwiftUIcon"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftUIcon",
            exclude: [
                "main.swift",
                "IconGenerator.swift"
            ],
            sources: ["Icon+PreviewHelpers.swift"]
        ),
    ]
)
