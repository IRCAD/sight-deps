cmake_minimum_required(VERSION 3.0)

project(libarchiveBuilder)

include(ExternalProject)

set(LIBARCHIVE_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                          -DENABLE_TEST:BOOL=OFF
)

set(CACHED_URL https://libarchive.org/downloads/libarchive-3.3.3.zip)

set(PATCH_CMD "")

if(ANDROID)
    list(APPEND LIBARCHIVE_CMAKE_ARGS
        -DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL}
    )
    set(PATCH_CMD "${PATCH_EXECUTABLE}" -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/patch/libarchive_android.diff -d <SOURCE_DIR>)

endif()

if(UNIX)
    list(APPEND LIBARCHIVE_CMAKE_ARGS -DENABLE_ICONV:BOOL=OFF -DENABLE_EXPAT:BOOL=ON)
    if(NOT CMAKE_SYSTEM_NAME STREQUAL Linux)
        set(LIBARCHIVE_DEPENDS zlib expat libxml)
    endif()
elseif(WIN32)
    list(APPEND LIBARCHIVE_CMAKE_ARGS -DENABLE_ICONV:BOOL=ON
                                      -DENABLE_EXPAT:BOOL=OFF
                                      -DCMAKE_C_FLAGS_DEBUG:STRING=/W2
    )
    set(LIBARCHIVE_DEPENDS zlib libiconv libxml)
endif()


ExternalProject_Add(
    libarchive
    URL ${CACHED_URL}
    URL_HASH SHA256=9b1c4f5f92c527f4767bb4806f083a765affbdbd915e6be0345a0be97d833dca
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS ${LIBARCHIVE_DEPENDS}
    PATCH_COMMAND ${PATCH_CMD}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${LIBARCHIVE_CMAKE_ARGS}
)
if(WIN32)
    ExternalProject_Add_Step(libarchive ZlibCopy
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_INSTALL_PREFIX}/bin/${ZLIB_LIB_NAME}.dll
                ${CMAKE_CURRENT_BINARY_DIR}/libarchive-prefix/src/libarchive-build/${ZLIB_LIB_NAME}.dll
        DEPENDEES download
        COMMENT "Copy ZLib"
    )
endif()

fwInstallFile(
    BINPKG libarchive
    SRC ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/fw-libarchive.cmake
    DEST ${CMAKE_INSTALL_PREFIX}/fw-libarchive.cmake
)
