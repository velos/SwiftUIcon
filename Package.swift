// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftUIcon",
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
