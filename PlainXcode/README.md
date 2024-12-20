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
  -destination "generic/platform=iOS" \ # use "iOS Simulator" to test on the simulator
  -derivedDataPath .build

xcodebuild \
  -project ReactNativeFramework.xcodeproj \
  -scheme ReactNativeFramework \
  -destination "generic/platform=iOS" \ # use "iOS Simulator" to test on the simulator
  -derivedDataPath .build
```

After we build the framework, we can inspect the output in the `.build` folder. In the folder, the most interesting subfolder is the `Build/Products/Debug-iphoneos`. This folder contains 2 .framework files: `ReactNativeFramework.framework` and `ReactRenderer.framework`.

We need to link both in the `ReactNativeFrameworkTestApp` to make it work.

Notice that if you build them with the generic platform `iOS`, the app will only run on a physical device. if you build them with the generic platform `iOS Simulator`, the app will only run on a simulator.

To have a framework that works with both, we need to create a fat framework:
1. Build both variants for iOS and iOS Simulator
2. merge them by running the command:
```shell
xcodebuild -create-xcframework \
  -framework .build/Build/Products/Debug-iphoneos/ReactNativeFramework.framework \
  -framework .build/Build/Products/Debug-iphonesimulator/ReactNativeFramework.framework \
  -output .output/ReactNativeFramework.xcframework

xcodebuild -create-xcframework \
  -framework .build/Build/Products/Debug-iphoneos/ReactRenderer.framework \
  -framework .build/Build/Products/Debug-iphonesimulator/ReactRenderer.framework \
  -output .output/ReactRenderer.xcframework
```
The two generated `.xcframework` files can now work with both phisical devices and simulators. The App store will strip from the XCFramework the slice of the binary for the simulator when the app is uploaded.

For further information, this is the [official documentation](https://developer.apple.com/documentation/xcode/creating-a-multi-platform-binary-framework-bundle).

### Special Build Settings

#### Header Search Path

Given the complex, non-standard folder structure of the ReactRenderer, we need to manually enhance the Header Search Path to make sure that the ReactNativeFramework target can access the headers of the ReactRenderer.

In Xocde:
- select the main project
- select the ReactNativeFrameworks target
- select Build Settings
- filter for `Header Search Path`
- double click the `Header Search Path` and add the line:
```
"${BUILD_DIR}/${CONFIGURATION}-${PLATFORM_NAME}/ReactRenderer.framework/Headers"
```

This string expands to the location where the Headers will be:
* The `BUILD_DIR` variable, define the folder where the frameworks will be built
* The `${CONFIGURATION}` part expands to your configuration, usually Debug or Release
* The `${PLATFORM_NAME}` expands to the sdk you are building for, for example `iphoneos`
* The final part points to the beginning of the path from where the app has to start looking for.

On iOS, the default search path is
```
${BUILD_DIR}/${CONFIGURATION}-${PLATFORM_NAME}/ReactRenderer.framework/
```

This let you import any of the exported headers by using:
```objc
#import <ReactRenderer/react/renderer/RCTReactRenderer.h>
```
Using this form, Xcode uses the `ReactRenderer` part to look for a framework with that name, and then it expects for the headers to the in the **Headers** folder.

In our case, we need to drop the `ReactRenderer` segment. To do so, we need to add a search path that helps Xcode in looking for what it needs. By specifying `"${BUILD_DIR}/${CONFIGURATION}-${PLATFORM_NAME}/ReactRenderer.framework/Headers"`, Xcode will also use this location to start looking for the headers. And we can see by inspecting the build folder that we indeed have the header at the path `react/renderer/RCTReactRenderer.h`.

#### Header configuration

When creating a new Framework, Xcode automatically creates an header file with your framework name that looks like it:
```objc
#import <Foundation/Foundation.h>

//! Project version number for TestFramework.
FOUNDATION_EXPORT double YourFrameworkVersionNumber;

//! Project version string for TestFramework.
FOUNDATION_EXPORT const unsigned char YourFrameworkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <TestFramework/PublicHeader.h>
```

And this will also be a public header.

This header can cause trouble if you need to import some C++ files in your objective-c files. This header is also not needed and we don't need for it to be a public header. So we can remove it and fix the problem if it happens.

#### Mergeable Libraries
When testing the creation of a framework, I explored the possibility to use mergeable libraries.
In Xcode:
- select the main project
- select the ReactNativeFrameworks target
- select Build Settings
- filter for `mergeable`
- set the `Create Merged Library` to `Automatic`.

This will enable the automatic creation of mergeable libraries. In theory, this should allow to export a single framework, the `ReactNativeFramework` that will re-export all the frameworks it depends on.

By building in Debug mode after setting this property, we can see that we have a folder called `ReexportedBinaries` in the path `/.build/Build/Products/Debug-iphoneos/ReactNativeFramework.framework`. The ReactNativeFramework binary is 87 Kb on disk, in Debug mode.

> [!CAUTION]
> The reexported framework does not have the Header folder in it. For this reaason, we need both frameworks in the app, if the app needs to use headers coming from the `ReactRenderer`.

If we build in Release mode, instead, we don't have the `ReexportedBinaries`. They should be merged into the binary of the framework itself.

> [!CAUTION]
> Even in release mode, the framework does not have the Header folder in it. For this reaason, we need both frameworks in the app, if the app needs to use headers coming from the `ReactRenderer`.

So far, the Mergeable Libraries does not seem to solve the problem of creating a single `XCFrameworks` for React Native.

#### TODO:
- [x] Try to manually move the Header folder from the ReactRenderer framework in the ReactNativeFramework framework and try to import it in the app
  - [x] In the Frameworks folder :x:
    - This does not work
  - [x] In the ReexportedBinaries folder :x:
    - This does not work
  - [x] In the main folder :white_check_mark:
    - This works but we need to change the import path to `ReactNativeFrameworks`.
    - The App builds and run.
    - We can write a script that moves all the headers from the subframeworks to the main framework
- [ ] Fix the warnings for the bridging headers and the ModuleMap creation.

### Simplify the Build

I manage to test how to build a unique XCFramework for multiple frameworks.

1. Set mergeable libraries enabled
2. Build all the targets, including the umbrella target
3. Move all the headers in the umbrella target
4. create the XCFrameworks

I organized all these steps in the `build.sh` script

Once the `ReactNativeFrameworks.xcframework` file is ready, drop that framework in the app.
Make sure to add the `${BUILD_DIR}/${CONFIGURATION}-${PLATFORM_NAME}/ReactNativeFrameworks.framework/Headers` to the `HEADER_SEARCH_PATH` Build Setting of the app.

## ReactNativeFrameworkTestApp

This is a simple iOS App created from Xcode.

It contains a default application where we changed the `SceneDelegate.m` to be an Objective-C++ file, so we renamed it to `SceneDelegate.mm`. Then we added the `#import <react/renderer/RCTReactRenderer.h>` and we added the code to initialize the renderer and to call the `render` function.

```c++
auto renderer = Renderer();
renderer.render();
```

The first thing we did to make it work was to drag and drop the `ReactNativeFramework.xcframework` and the `ReactRenderer.xcframework` folders in the `Frameworks, Library, and Embedded Content` section of the `ReactNativeFrameworkTestApp` target.

Then, we had to provide again the custom `Header Search Paths` that we provided for the `ReactNativeFramework` project.

In Xocde:
- select the main project
- select the `ReactNativeFrameworksTestApp` target
- select `Build Settings`
- filter for `Header Search Path`
- double click the `Header Search Path` and add the line:
```
"${BUILD_DIR}/${CONFIGURATION}-${PLATFORM_NAME}/ReactRenderer.framework/Headers"
```
