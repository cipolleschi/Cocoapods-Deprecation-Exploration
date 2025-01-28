// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReactNative",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ReactNative",
            targets: ["ReactNative"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/softwaremansion/react-native-reanimated.git", from: "5.0.0")
    ],
    targets: [
        .binaryTarget(
          name: "ReactNative",
          path: "../ReactNative/.output/ReactNative.xcframework"
        ),
    ]
)
