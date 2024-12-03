// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "nyPB",
    products: [
        .executable(name: "pb-tester", targets: ["pb-tester"]),
        .library(name: "nyPB", targets: ["nyPB"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.1.3"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0")
    ],
    targets: [
        .executableTarget(name: "pb-tester", dependencies: [
            "nyPB",
            .product(name: "Yams", package: "Yams"),
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
        ]),
        .target(name: "nyPB"),
        .testTarget(name: "nyPBTests",
            dependencies: ["nyPB"]
        ),
    ]
)
