// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "nyPB",
    products: [
        .executable(name: "pb-tester", targets: ["pb-tester"]),
        .library(name: "nyPB", targets: ["nyPB"]),
    ],
    targets: [
        .executableTarget(name: "pb-tester", dependencies: ["nyPB"]),
        .target(name: "nyPB"),
        .testTarget(name: "nyPBTests",
            dependencies: ["nyPB"]
        ),
    ]
)
