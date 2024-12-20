# Plain Xcode

This folder contains the exploration of using a plain Xcode project to build React Native and to generate prebuilds.

The folder contains two projects:
- **ReactNativeFramework**: this folder contains the proper Xcode project that contains React Native framework.
- **ReactNativeFrameworkTestApp**: this folder contains an App generated with Xcode on which we can drop the xcframeworks generated from the **ReactNativeFramework** folder

Given that this is a POC, the **ReactNativeFramework** folder does not contains the full version of React native, but just a module with one of the most complex configurations to verify that we can build it preserving the import paths that we need.

## ReactNativeFramework folder

To use the **ReactNativeFramework** folder, double click on the `ReactNativeFramework.xcodeproj` to load the project in Xcode.

In the project there will be 2 targets:
- The `ReactNativeFramework` target
- The `ReactRenderer` target

The `ReactNativeFramework` is a dummy target that depends on the `ReactRenderer` target. It only contains a `Dummy.h` file and a `Dummy.mm` file that imports the `ReactRenderer` with the statement

```objc
#import <react/renderer/RCTReactRenderer.h>
```

The React Renderer is then initialized and used in the `render` function of the Dummy object.

The `ReactRenderer` is a simple C++ framework with a `RCTReactRenderer.h` file that defines the `Renderer` class, and a `RCTReactRenderer.cpp` file that implement the class.

It's possible to build both frameworks through Xcode, or by using xcodebuild.

```bash
xcodebuild \
  -project ReactNativeFramework.xcodeproj \
  -scheme ReactRenderer \
  -destination "generic/platform=iOS" \
  -derivedDataPath .build

xcodebuild \
  -project ReactNativeFramework.xcodeproj \
  -scheme ReactNativeFramework \
  -destination "generic/platform=iOS" \
  -derivedDataPath .build
```
