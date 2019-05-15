// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "ansiDemo",
    dependencies: [
        .package(url: "https://github.com/pakLebah/ANSITerminal", from: "0.0.2"),
    ],
    targets: [
        .target(
            name: "ansiDemo",
            dependencies: ["ANSITerminal"],
            path: "Sources"),
        // .testTarget(
        //     name: "ansiDemoTests",
        //     dependencies: ["ansiDemo"]),
    ]
)
