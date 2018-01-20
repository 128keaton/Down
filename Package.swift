import PackageDescription

let package = Package(
    name: "Down",
    products: [
        .library(name: "Down", targets: ["Down"]),
        ],
    targets: [
        .target(
            name: "Down"),
        .testTarget(
            name: "DownTests",
            dependencies: ["Down"]),
        ]
)
