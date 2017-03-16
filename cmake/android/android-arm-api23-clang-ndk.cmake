# Find Android NDK
if(DEFINED ENV{ANDROID_NDK})
    set(ANDROID_NDK "$ENV{ANDROID_NDK}" CACHE PATH "Path to the Android NDK")
    file(TO_CMAKE_PATH "${ANDROID_NDK}" ANDROID_NDK)
else()
    message(FATAL_ERROR "Can not find android NDK path, please set the path in env var 'ANDROID_NDK'")
endif()

# As seen at https://cmake.org/cmake/help/v3.7/manual/cmake-toolchains.7.html#cross-compiling-for-android
set(CMAKE_SYSTEM_NAME Android)
set(CMAKE_SYSTEM_VERSION 23)
set(CMAKE_ANDROID_ARCH_ABI armeabi-v7a)
set(CMAKE_ANDROID_ARM_MODE ON)
set(CMAKE_ANDROID_ARM_NEON ON)
set(CMAKE_ANDROID_NDK ${ANDROID_NDK})
set(CMAKE_ANDROID_STL_TYPE c++_shared)

# Use clang as compiler as gcc is deprecated
set(CMAKE_ANDROID_NDK_TOOLCHAIN_VERSION clang)

# Not sure this is really needed
remove_definitions(-DANDROID)
add_definitions(-DANDROID)
