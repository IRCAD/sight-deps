cmake_minimum_required(VERSION 3.0)

project(openvslamBuilder)

include(ExternalProject)


set(OPENVSLAM_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                           -DDBOW_FRAMEWORK:STRING=DBoW2
                           -DBUILD_TESTS:BOOL=OFF
                           -DUSE_PANGOLIN_VIEWER:BOOL=OFF
                           -DBUILD_EXAMPLES:BOOL=OFF
                           -DUSE_CCACHE:BOOL=OFF
)

set(CACHED_URL https://github.com/IRCAD-IHU/openvslam/archive/v0.0.2.zip)

ExternalProject_Add(
    openvslam
    URL ${CACHED_URL}
    URL_HASH SHA256=84d1ad91e737bb372625cb78d04d676a9bde0d95ebdfcd79ed18dea07668e77f
    DEPENDS g2o pangolin dbow2
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME openvslam.tar.gz
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${OPENVSLAM_CMAKE_ARGS}
)
