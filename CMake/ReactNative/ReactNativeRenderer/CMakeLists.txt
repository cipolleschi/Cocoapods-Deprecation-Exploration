# CMakeLists.txt
cmake_minimum_required(VERSION 3.10)
set(CMAKE_VERBOSE_MAKEFILE on)

set(BUILD_SHARED_LIBS ON)
set(CMAKE_OSX_ARCHITECTURES arm64)
set(CMAKE_SYSTEM_NAME iOS)
set(CMAKE_OSX_DEPLOYMENT_TARGET "15.1")
set(CMAKE_XCODE_ATTRIBUTE_ONLY_ACTIVE_ARCH OFF)
set(CMAKE_IOS_INSTALL_COMBINED ON)
set(CMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM "C4V9EZM2B6")

add_compile_options(
        -fexceptions
        -frtti
        -O3
        -Wno-unused-lambda-capture
        -DLOG_TAG=\"ReactNative\")


# Define the library
add_library(ReactNativeRenderer SHARED
    react/renderer/ReactRenderer.cpp
)

# Set the include directory
target_include_directories(ReactNativeRenderer PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/react/renderer
    ${CMAKE_CURRENT_SOURCE_DIR}
)

set_target_properties(ReactNativeRenderer PROPERTIES FRAMEWORK TRUE)
