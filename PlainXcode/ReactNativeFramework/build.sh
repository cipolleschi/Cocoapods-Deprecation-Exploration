rm -rf .build
# build for simulator

xcodebuild \
   -project ReactNativeFramework.xcodeproj \
  -scheme ReactRenderer \
  -destination "generic/platform=iOS Simulator" \
  -derivedDataPath .build

xcodebuild \
  -project ReactNativeFramework.xcodeproj \
  -scheme ReactNativeFramework \
  -destination "generic/platform=iOS Simulator" \
  -derivedDataPath .build

# build for ios
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

# Copy Header Files
cp -R .build/Build/Products/Debug-iphoneos/ReactRenderer.framework/Headers .build/Build/Products/Debug-iphoneos/ReactNativeFramework.framework/Headers
cp -R .build/Build/Products/Debug-iphonesimulator/ReactRenderer.framework/Headers .build/Build/Products/Debug-iphonesimulator/ReactNativeFramework.framework/Headers

# Create XCFramework
rm -rf .output
xcodebuild -create-xcframework \
  -framework .build/Build/Products/Debug-iphoneos/ReactNativeFramework.framework \
  -framework .build/Build/Products/Debug-iphonesimulator/ReactNativeFramework.framework \
  -output .output/ReactNativeFramework.xcframework
