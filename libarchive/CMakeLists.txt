cmake_minimum_required(VERSION 3.0)

project(libarchiveBuilder)

include(ExternalProject)

set(LIBARCHIVE_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                          -DENABLE_TEST:BOOL=OFF
)

set(CACHED_URL http://www.libarchive.org/downloads/libarchive-3.3.1.zip)

set(PATCH_CMD "")

if(ANDROID)
    # For an unknown reason the android include files are not added to include path.
    # simply copy it near the cpp files that require it, so we don't have to add an painful patch
    set(PATCH_CMD ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/contrib/android/include/android_lf.h <SOURCE_DIR>/libarchive
        COMMAND ${PATCH_EXECUTABLE} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/patch/android-linux.diff -d <SOURCE_DIR>
        )
endif()

if(UNIX)
    list(APPEND LIBARCHIVE_CMAKE_ARGS -DENABLE_ICONV:BOOL=OFF -DENABLE_EXPAT:BOOL=ON)
    set(LIBARCHIVE_DEPENDS zlib expat libxml)
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
    URL_HASH SHA256=2af56ff8428c8e896df98325509b361ce5d1328e2f0c1fcdc6bb38e24875f83b
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

ExternalProject_Add_Step(libarchive CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/fw-libarchive.cmake ${CMAKE_INSTALL_PREFIX}/fw-libarchive.cmake
    COMMENT "Install configuration file"
    DEPENDEES install
)

if(ANDROID)
    ExternalProject_Add_Step(libarchive CopyAndroidHeader
        COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/contrib/android/include/android_lf.h ${CMAKE_INSTALL_PREFIX}/include
        COMMENT "Install missing android header file"
        DEPENDEES install
    )
endif()

