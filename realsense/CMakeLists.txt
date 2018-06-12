cmake_minimum_required(VERSION 3.0)

project(realsense)

include(ExternalProject)

set(REALSENSE_VERSION "2.12.0")
set(CACHED_URL https://github.com/IntelRealSense/librealsense/archive/v${REALSENSE_VERSION}.tar.gz)

set(REALSENSE_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                         -DBUILD_EXAMPLES=OFF
)

ExternalProject_Add(
    realsense
    URL ${CACHED_URL}
    URL_HASH SHA256=e518133ed20ad215e68b62c56d08097d0843cb374f3928ba3cf82c9fc15857bc
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME realsense-${REALSENSE_VERSION}.tar.gz
    DEPENDS ${REALSENSE_DEPENDS}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${REALSENSE_CMAKE_ARGS}
)
