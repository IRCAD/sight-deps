cmake_minimum_required(VERSION 3.0)

project(dbow2Builder)

include(ExternalProject)


set(DBOW2_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                           -DBUILD_DBoW2:BOOL=ON
                           -DBUILD_UTIL:BOOL=OFF
)

set(CACHED_URL https://github.com/shinsumicco/DBoW2/archive/adff102d4f1041978f7b785b5221354cc3c2ec0f.zip)

ExternalProject_Add(
    dbow2
    URL ${CACHED_URL}
    URL_HASH SHA256=a0b6e8fa95b07babd935c60d60725b7a9bc081262bf48e615ee6800e0c33a38e
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME dbow2.tar.gz
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${DBOW2_CMAKE_ARGS}
)