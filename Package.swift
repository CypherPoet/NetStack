// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetStack",
    platforms: [
        .iOS(SupportedPlatform.IOSVersion.v13),
        .macOS(SupportedPlatform.MacOSVersion.v10_15),
        .tvOS(SupportedPlatform.TVOSVersion.v13),
        .watchOS(SupportedPlatform.WatchOSVersion.v6),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "NetStack",
            targets: ["NetStack"]
        ),
        .library(
            name: "NetStackTestUtils",
            targets: ["NetStackTestUtils"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "NetStack",
            dependencies: [],
            path: "Sources/Core"
        ),
        .target(
            name: "NetStackTestUtils",
            dependencies: [
                "NetStack",
            ],
            path: "Sources/TestUtils"
        ),
        .testTarget(
            name: "NetStackTests",
            dependencies: [
                "NetStack",
                "NetStackTestUtils",
            ],
            path: "Tests/",
            resources: [
                .process("./Data/headline.txt"),
                .process("./Data/weather-data.json"),
            ]
        ),
    ]
)
