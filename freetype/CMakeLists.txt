cmake_minimum_required(VERSION 3.0)

project(freetypeBuilder)

include(ExternalProject)

set(CACHED_URL https://download.savannah.gnu.org/releases/freetype/freetype-2.9.tar.gz)


set(FREETYPE_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(FREETYPE_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                        -DBUILD_SHARED_LIBS:BOOL=ON
                        -DDISABLE_FORCE_DEBUG_POSTFIX=ON

)
ExternalProject_Add(
    freetype
    URL ${CACHED_URL}
    URL_HASH SHA256=bf380e4d7c4f3b5b1c1a7b2bf3abb967bda5e9ab480d0df656e0e08c5019c5e6
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS zlib
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${FREETYPE_CMAKE_ARGS}
)
