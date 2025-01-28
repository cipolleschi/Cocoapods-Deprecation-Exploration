# CMakeLists.txt
cmake_minimum_required(VERSION 3.10)
set(CMAKE_VERBOSE_MAKEFILE on)


set(BUILD_SHARED_LIBS ON)
set(CMAKE_OSX_ARCHITECTURES "arm64")
set(CMAKE_SYSTEM_NAME "iOS")
set(CMAKE_OSX_DEPLOYMENT_TARGET "15.1")
set(CMAKE_XCODE_ATTRIBUTE_ONLY_ACTIVE_ARCH OFF)
set(CMAKE_IOS_INSTALL_COMBINED ON)
set(CMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM "C4V9EZM2B6")
project(ReactNative)

add_compile_options(
        -fexceptions
        -frtti
        -O3
        -Wno-unused-lambda-capture
        -DLOG_TAG=\"ReactNative\")

# Add subdirectory for ReactNativeRenderer library
add_subdirectory(../ReactNativeRenderer .build/ReactNativeRenderer EXCLUDE_FROM_ALL)

# Define the library
add_library(ReactNative SHARED
    Dummy.mm
)
# Set the include directory
target_include_directories(ReactNative PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)
# Link against ReactNativeRenderer library
target_link_libraries(ReactNative
    ReactNativeRenderer
)

set_target_properties(ReactNative PROPERTIES FRAMEWORK TRUE)
