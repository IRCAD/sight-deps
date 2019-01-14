cmake_minimum_required(VERSION 3.0)

project(realsense)

include(ExternalProject)

set(REALSENSE_VERSION "2.17.0")
set(CACHED_URL https://github.com/IntelRealSense/librealsense/archive/v${REALSENSE_VERSION}.tar.gz)

set(REALSENSE_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                         -DBUILD_EXAMPLES=OFF
                         -DBUILD_GRAPHICAL_EXAMPLES=OFF
                         -DBUILD_WITH_TM2=OFF
)

ExternalProject_Add(
    realsense
    URL ${CACHED_URL}
    URL_HASH SHA256=fe8fb031d6a2b45cb563a44b142cbf5d669cd229a325567a0f1350ccfea89e3c
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME realsense-${REALSENSE_VERSION}.tar.gz
    DEPENDS ${REALSENSE_DEPENDS}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${REALSENSE_CMAKE_ARGS}
)
