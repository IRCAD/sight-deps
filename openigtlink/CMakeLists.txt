cmake_minimum_required(VERSION 3.0)

project(openigtlinkBuilder)

include(ExternalProject)

set(OPENIGTLINK_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                           -DBUILD_TESTING:BOOL=OFF
                           -DBUILD_EXAMPLES:BOOL=OFF
                           -DBUILD_DOCUMENTATION:BOOL=OFF
                           -DBUILD_SHARED_LIBS:BOOL=ON
                           -DOpenIGTLink_PROTOCOL_VERSION_2:BOOL=ON
)

if(UNIX)
        # Allows to reuse server sockets after they are closed.
        # We need that otherwise we can't restart a sender on the same port during a application run.
        # The define flag looks strange, but yes this code seems to come from VTK
        # See Source/igtlSocket.cxx:116
        list(APPEND OPENIGTLINK_CMAKE_ARGS -DCMAKE_CXX_FLAGS=-DVTK_HAVE_SO_REUSEADDR ${CMAKE_CXX_RELEASE})
endif()

if(APPLE)
    list(APPEND PATCH_CMD
        COMMAND ${PATCH_EXECUTABLE} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/patch/macos_socket_deadlock_workaround.diff -d <SOURCE_DIR>
    )
endif()

if(ANDROID)
    # Android doesn't need to link with pThread lib so we need to remove it from target link library
    list(APPEND PATCH_CMD
        COMMAND ${PATCH_EXECUTABLE} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/patch/android_pthread.diff -d <SOURCE_DIR>
    )
endif()

set(CACHED_URL https://github.com/openigtlink/OpenIGTLink/archive/5a501817c2da52e81db4db3eca6dd5111f94fed9.tar.gz)

ExternalProject_Add(
    openigtlink
    URL ${CACHED_URL}
    URL_HASH SHA256=669b34e4a1dd545b3af24514f2f068bc83a0fb8db11e8c34e5f7574e5accc500
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME openigtlink.tar.gz
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    PATCH_COMMAND ${PATCH_CMD}
    CMAKE_ARGS ${OPENIGTLINK_CMAKE_ARGS}
)

fwInstallFile(
    BINPKG openigtlink
    SRC ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/fw-IGTL.cmake
    DEST ${CMAKE_INSTALL_PREFIX}/fw-IGTL.cmake
)
