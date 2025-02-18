// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReactNative",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ReactNative",
            type: .dynamic,
            targets: ["ReactNative", "React"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ReactNative",
            dependencies: ["ReactRenderer"],
            path: "Sources/ReactNative",
            publicHeadersPath: ".",
            linkerSettings: [
              .linkedFramework("Foundation")
            ]
        ),
        .target(
          name: "ReactRenderer",
          dependencies: [],
          path: "Sources/ReactRenderer",
          sources: ["cpp"],
          publicHeadersPath: "cpp",
          linkerSettings: [
            .linkedFramework("Foundation")
          ]
        ),
        .target(
          name: "React",
          dependencies: [],
          path: "Sources/React",
          sources: ["."],
          publicHeadersPath: ".",
          linkerSettings: [
            .linkedFramework("Foundation"),
            .linkedFramework("UIKit")
          ]
        )
    ]
)
