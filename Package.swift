// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Meta",
    products: [
        .library(name: "Meta", targets: ["Meta"])
    ],
    targets: [
        .target(name: "Meta", dependencies: []),
        .testTarget(name: "MetaTests", dependencies: ["Meta"])
    ]
)
