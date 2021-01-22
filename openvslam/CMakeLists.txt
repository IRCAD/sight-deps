cmake_minimum_required(VERSION 3.0)

project(openvslamBuilder)

include(ExternalProject)


set(OPENVSLAM_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                           -DDBOW_FRAMEWORK:STRING=DBoW2
                           -DBUILD_TESTS:BOOL=OFF
                           -DUSE_PANGOLIN_VIEWER:BOOL=OFF
                           -DBUILD_EXAMPLES:BOOL=OFF
                           -DUSE_CCACHE:BOOL=OFF
                           -DUSE_OPENMP:BOOL=ON
                           -DUSE_SSE_ORB:BOOL=ON
                           -DUSE_SSE_FP_MATH:BOOL=ON
)

set(CACHED_URL https://github.com/xdspacelab/openvslam/archive/29435e14513a437719952ba916e5994e71ea6e55.zip)

ExternalProject_Add(
    openvslam
    URL ${CACHED_URL}
    URL_HASH SHA256=d64f7aab2a5b3a5ee6894ef54c99c545047dea6cb75155e1ad8b9be87c96aa08
    DEPENDS g2o pangolin dbow2
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME openvslam.tar.gz
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${OPENVSLAM_CMAKE_ARGS}
)
