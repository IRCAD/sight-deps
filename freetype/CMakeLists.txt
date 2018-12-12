cmake_minimum_required(VERSION 3.0)

project(freetypeBuilder)

include(ExternalProject)

set(CACHED_URL https://download.savannah.gnu.org/releases/freetype/freetype-2.9.1.tar.gz)


set(FREETYPE_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(FREETYPE_PATCH_CMD "${PATCH_EXECUTABLE}" -p1 -i "${FREETYPE_PATCH_DIR}/CMakeLists.patch" -d "<SOURCE_DIR>")

set(FREETYPE_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                        -DBUILD_SHARED_LIBS:BOOL=ON
                        -DDISABLE_FORCE_DEBUG_POSTFIX=ON

)
ExternalProject_Add(
    freetype
    URL ${CACHED_URL}
    URL_HASH SHA256=ec391504e55498adceb30baceebd147a6e963f636eb617424bcfc47a169898ce
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    PATCH_COMMAND ${FREETYPE_PATCH_CMD}
    DEPENDS zlib
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${FREETYPE_CMAKE_ARGS}
)
