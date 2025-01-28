## CMake

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

The build process will generate a `Debug-iphonesimulator/ReactNative.framework` inside the `_builds` folder.
