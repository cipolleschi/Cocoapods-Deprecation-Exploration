# SPM

This folder contains the exploration of using Swift Package Manager to build React Native and to generate prebuilds.

The folder contains two projects:
- **ReactNative**: this folder contains the proper SPM package that describe React Native.
- **ReactNativeApp**: this folder contains an App generated with Xcode that integrates with React Native defined by SPM.

Given that this is a POC, the SPM folder does not contains the full version of React native, but just a module with one of the most complex configurations to verify that we can build it preserving the import paths that we need.

## ReactNative folder

To use the React native project, you can double click on the `Package.swift` file. This will open Xcode and you can explore the project.

You can see that there are two folders: **ReactNative** and **ReactRenderer**.

**ReactNative** is an Objective-C++ package that imports the **ReactRenderer** using the import `react/renderer/ReactRenderer.h`.

**ReactRenderer** is a C++ package that defines a `Renderer` class and exposes a `render()` method that is empty.

From Xcode, you can build the **ReactNative** target. In turn, it will build the **ReactRenderer** target.

You can build the frameworks from the command line with the command:

```bash
xcodebuild \
  -scheme ReactNative  \
  -destination "generic/platform=iOS" \
  -derivedDataPath .build

xcodebuild \
  -scheme ReactRenderer  \
  -destination "generic/platform=iOS" \
  -derivedDataPath .build

```

This will build the project in the `.build` folder so we can inspect what has been built. In the path `.build/Build/Products/Debug-iphoneos` we can find the final product of the build. We can observe hat there are two binaries for the `.o` files that have been built. In the `PackageFrameworks` folder, we have the `ReactNative` framework binary.

> [!CAUTION]
> Observe that there are no header files there! This is a problem as it means that a user of the Framework can not import the `ReactRenderer.h` file!

### TODO:
- [X] try to expose also the React Renderer as a `.product` in Swift PM
- [X] try to build both frameworks
- [X] verify that the headers are exported in the build folder
  - The Header folder has not been created and public headers have not been moved to the artifact.
- [ ] try to import the frameworks in a Xcode project to see if they works
- [ ] if they works, try to define another version of package.swift that use binaries and integrate that with the project

I tried to define another product for the ReactNative's `Package.swift`, and I tried to create xcframeworks from them. I verified that xcodebuild does not create the Haeder folder in the `.framework` folder.

## ReactNativeApp folder

The React Native App folder is an iOS app created from Xcode.

To open it, double click on the `ReactNativeApp.xcodeproj` file. The app is integrated with the ReactNative Swift Package locally.

> [!NOTE]
> You need to close the ReactNative project to properly open this app. Xcode can't handle having both the Swift Package and the Xcode project using the package open at the same time.

The app imports the `ReactRenderer` using the import `<react/renderer/ReactRenderer.h>` in the `SceneDelegate.mm`.

This app is the test bed that we can use to experiment with Swift PM.
