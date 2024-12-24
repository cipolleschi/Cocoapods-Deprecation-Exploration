// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReactNative",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ReactNativeSource",
            type: .dynamic,
            targets: ["ReactNativeSource"]
        ),
        .library(
            name: "ReactNative",
            targets: ["ReactNative"]
        ),
        // .library(
        //     name: "ReactRenderer",
        //     type: .dynamic,
        //     targets: ["ReactRenderer"]
        // ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ReactNativeSource",
            dependencies: ["ReactRenderer"],
            path: "Sources/ReactNative",
            publicHeadersPath: ".",
            linkerSettings: [
              .linkedFramework("Foundation")
            ]
        ),
        .binaryTarget(
          name: "ReactNative",
          path: ".output/ReactNative.xcframework"
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
    ]
)
