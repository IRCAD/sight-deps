cmake_minimum_required(VERSION 3.0)

project(pangolinBuilder)

include(ExternalProject)


set(PANGOLIN_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                           -DBUILD_TESTS:BOOL=OFF
                           -DBUILD_TOOLS:BOOL=ON
                           -DBUILD_EXAMPLES:BOOL=OFF
                           -DBUILD_SHARED_LIBS:BOOL=OFF
                           -DBUILD_EXTERN_GLEW:BOOL=OFF
                           -DBUILD_EXTERN_LIBPNG:BOOL=OFF
                           -DBUILD_EXTERN_LIBJPEG:BOOL=OFF
                           -DBUILD_PANGOLIN_EIGEN:BOOL=OFF
)

set(CACHED_URL https://github.com/stevenlovegrove/Pangolin/archive/11e2ecb7df02989a219e9270b9c2c96858b99ed6.zip)

ExternalProject_Add(
    pangolin
    URL ${CACHED_URL}
    URL_HASH SHA256=abbffe4c3f5a31dc4f5a524274f4f941683e6057cb7142725980b8485aaa4b44
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME pangolin.tar.gz
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${PANGOLIN_CMAKE_ARGS}
)
