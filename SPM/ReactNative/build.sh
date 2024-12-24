# Invoke the script with ./build.sh <Signing Identity>.
# The signing identity is the ID you use to sign your application
# We might need to load the identity in CI and to store it in the mac executor
# This can be easily automated with the keychain CLI

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
echo "\n>>> Copying the Headers\n"
cp -R Sources/ReactRenderer/cpp/react/renderer/*.h .build/Build/Products/Debug-iphoneos/PackageFrameworks/ReactNative.framework/Headers/react/renderer/
cp -R Sources/ReactRenderer/cpp/react/renderer/*.h .build/Build/Products/Debug-iphonesimulator/PackageFrameworks/ReactNative.framework/Headers/react/renderer/

# Sign the .framework files
if [[ ! -z $1 ]]; then
  echo "\n>>> Signing the frameworks\n"
  IDENTITY=$1
  codesign --timestamp -s "$IDENTITY" .build/Build/Products/Debug-iphoneos/PackageFrameworks/ReactNative.framework
  codesign --timestamp -s "$IDENTITY" .build/Build/Products/Debug-iphonesimulator/PackageFrameworks/ReactNative.framework
fi

# Remove .output folder
rm -rf .output

# Create xcframework
echo "\n>>> Creating the frameworks"
xcodebuild -create-xcframework \
  -framework .build/Build/Products/Debug-iphoneos/PackageFrameworks/ReactNative.framework \
  -framework .build/Build/Products/Debug-iphonesimulator/PackageFrameworks/ReactNative.framework \
  -output .output/ReactNative.xcframework
