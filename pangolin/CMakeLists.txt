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

set(CACHED_URL https://github.com/stevenlovegrove/Pangolin/archive/86eb4975fc4fc8b5d92148c2e370045ae9bf9f5d.zip)

ExternalProject_Add(
    pangolin
    URL ${CACHED_URL}
    URL_HASH SHA256=c6f6f23b139517f55a99efc5a917b9fb599c879fa8809728b86330297d18c991
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME pangolin.tar.gz
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${PANGOLIN_CMAKE_ARGS}
)
