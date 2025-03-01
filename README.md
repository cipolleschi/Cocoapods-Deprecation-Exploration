# Cocoapods Deprecation Exploration

This is an exploratory repository that contains various experiments I'm running to see what's the best path toward deprecating Cocoapods in React Native.

The exploration goal is to find a good alternative to fulfill the following requirements:
1. Should allow users to build React Native from source.
2. Should allow users to generate prebuilds for iOS. Prebuilds will be integrated n the final app using Swift Package Manager (SPM)
3. Should allow us to remove responsibilities from Cocoapods.

React Native for iOS is currently built from source, using Cocoapods. Building rom source is an important feature that we want to preserve: it makes it easier to debug what's happening in React Native, it makes it easy to patch React native if needed, and it allows out-of-tree platforms (OOT) to build properly.

On the other side, it is really pointless to force millions of users to rebuild React Native locally every time. The majority of our users does not need to build React Native from source and we can save time and the environment if we can generate and distribute prebuilds for the default use case.

Finally, Cocoapods is a dependency management system (DMS) which we use to configure the Xcode project and workspace to let `xcodebuild` build properly. cocoapods is written in Ruby and, over time, we abused of its flexibility. We now use Cocoapods to do much more than what they should do. For example, we use it to build Codegen, to run Codegen and to configure various flags. The final solution should **factor out** these behaviors that are independent from the DMS we decide to use. Factoring this out will make it easier to change and replace DMS in the future.

## Exploration paths

In this Repository, we will explore various alternatives, and you can find a different folder for each alternative. Each folder has its own README.md with a description of the solution and some instructions on how to use it.

- **Swift Package Manager (SPM)**: SPM is the DMS developed by Apple. It allows to describe the project using Swift in a declarative way. It can't be used to prepare app projects, but it supports libraries, which is what we need for React Native.
- **Plain Xcode**: Xcode is the Apple IDE and it allow to configure complex projects if needed. We can try to set up a project in a way that consumes files from React Native as symlinks and use it to build from source and to prepare prebuilds.
- **CMake**: Cmake is a tool that let users configure a project of any complexity. The tehnology that is then used to build the project is independent from Cmake, and we would like to use `xcodebuild`. Cmake is appealing as part of the Android build logic is already described by Cmake and we can share code between the platforms.

## Other approaches

There are other approaches that we can explore, to achieve intermediate results.
For example, we can keep using Cocoapods to generate prebuilds. This can provide us more time to fid the best alternative to replace Cocoapods, reducing the exposure to Apple whims.

Some possible ways to achieve this:
1. When we run `pod install`, Cocoapods generates a `Pods.xcodeproj` file in the `Pods` folder. We can try to open that file to see if we can use it as starting point to generate prebuilds.
2. We can explore some cocoapods plugins like [`cocoapods pack`](https://github.com/square/cocoapods-pack) or [`cocoapods packager`](https://github.com/CocoaPods/cocoapods-packager)
3. ~~We can try to create a React Native project, using the Cocoapods infrastructure and try to build React Native as if it was a library with Cocoapods dependencies. And see where the items ends up. This is what we are exploring in the Cocoapods folder.~~
Tested hp 3 and it doesn't work: Cocoapods does not merges the symbols of individual frameworks into the final one, so this is not a good solution.
