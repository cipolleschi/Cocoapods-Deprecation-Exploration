# CMake

This folder contains an experiment to try and generate an Xcode project using Cmake.

The folder structure is the following:

```
Cmake
├── ReactNative
│   ├── ReactNative
│   └── ReactNativeRenderer
└── ReactNativeApp
```

## ReactNative

This folder contains the ReactNative framework, using the same structure used in the other folders:
- We have the `ReactNative` top-level Frameworks
- We have the `ReactNativeRenderer` that contains a simple `ReactRenderer` file in C++

Both folders also contains the CMakeLists.txt files that allow to create the `Xcode` project

## ReactNativeApp

This folder contains a simple App the is created by Xcode.

This is the testbed we use to try and integrate the framework that we generate from the ReactNative folder.

## Tests

To prepare the project, run the following command from the CMake/ReactNative/ReactNative folder:

```
make -S . -B _builds -G Xcode
```

This will run all the CMake shenanigans and it generates the output in the `_builds` folder

You can open xcode by running:

```
open _builds/ReactNative.xcodeproj
```

From the drop down, you can select the target you want. If you select the simulator, you can then build pressing <kbd>⌘</kbd>+<kbd>B<kbd>.
Another way to build is by using this script from the the `_builds` folder.

```sh
xcodebuild \
  -scheme ReactNative  \
  -destination "generic/platform=iOS" \
  -derivedDataPath .build
```

The build process will generate a `Debug-iphone/ReactNative.framework` inside the `_builds` folder.

At this point, we can manually recreate the Header structure by:
- Create the `Debug-iphone/ReactNative.framework/Headers/react/renderer` path
- Copy the `dummy.h` file and paste it into the `Debug-iphone/ReactNative.framework/Headers` path
- Copy the `ReactRenderer.h` file and paste it into the `Debug-iphone/ReactNative.framework/Headers/react/renderer` path

Now, we can copy the `ReactNative.framework` file and paste it in the `ReactNativeApp/CMakeApp` path, at the same level of the `xcodeproj` file.

Opening Xcode, we can now drag and drop the `ReactNative.framework` into the `Frameworks, Libraries and Embedded contents` section of the app and try to build.

The build will fail with the error:
```
:stop: Undefined symbols for architecture arm64: "Renderer::render()"
```
This is a sign that the symbol is missing from the framework.

### Mergeable Libraries

One thing I tried was to try and enable `Mergeable Libraries` in Xcode and build again.

This attempt failed, Xcode was not generating the extra binaries in the Framework.

### Copying the ReactNativeRenderer.framework into the ReactNative.framework

Another thing I tried was to manually create a `Frameworks` folder in the `ReactNative.framework` bundle and to copy the `ReactNativeRenderer.framework` file inside that folder.

This is the typical structure of a Complex framework which depends on additional frameworks.

I then tried to integrate this new framework in the app, but the result is the same error:

```
:stop: Undefined symbols for architecture arm64: "Renderer::render()"
```
