# Remove build folder
rm -rf .build

# Build frameworks
xcodebuild \
  -scheme ReactNative  \
  -destination "generic/platform=iOS" \
  -derivedDataPath .build

xcodebuild \
  -scheme ReactNative  \
  -destination "generic/platform=iOS Simulator" \
  -derivedDataPath .build

# Create Headers folder
mkdir -p \
  .build/Build/Products/Debug-iphoneos/PackageFrameworks/ReactNative.framework/Headers/react/renderer \
  .build/Build/Products/Debug-iphonesimulator/PackageFrameworks/ReactNative.framework/Headers/react/renderer

# Copy headers
cp -R Sources/ReactRenderer/cpp/react/renderer/*.h .build/Build/Products/Debug-iphoneos/PackageFrameworks/ReactNative.framework/Headers/react/renderer/
cp -R Sources/ReactRenderer/cpp/react/renderer/*.h .build/Build/Products/Debug-iphonesimulator/PackageFrameworks/ReactNative.framework/Headers/react/renderer/

# Remove .output folder
rm -rf .output

# Create xcframework
xcodebuild -create-xcframework \
  -framework .build/Build/Products/Debug-iphoneos/PackageFrameworks/ReactNative.framework \
  -framework .build/Build/Products/Debug-iphonesimulator/PackageFrameworks/ReactNative.framework \
  -output .output/ReactNative.xcframework
