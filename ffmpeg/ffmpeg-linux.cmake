#FFMPEG CMake script for Linux

set(FFMPEG_URL "https://ffmpeg.org/releases/ffmpeg-4.3.1.tar.xz")
set(FFMPEG_HASHSUM ad009240d46e307b4e03a213a0f49c11b650e445b1f8be0dda2a9212b34d2ffb)

set(CACHED_URL ${FFMPEG_URL})

include(FindPkgConfig)

pkg_search_module(LIBX264 REQUIRED x264)
pkg_search_module(LIBX265 REQUIRED x265)

# ffmpeg configuration so it is build with the needed packages
set(FFMPEG_CONFIGURE_CMD
     PKG_CONFIG_PATH=${CMAKE_INSTALL_PREFIX}/lib/pkgconfig ./configure
    --prefix=${CMAKE_INSTALL_PREFIX}
    --enable-gpl
    --extra-cflags="-I${CMAKE_INSTALL_PREFIX}/include"
    --extra-ldflags="-L${CMAKE_INSTALL_PREFIX}/lib"
    --enable-libx264 # Basic encoders
    --enable-libx265
    --disable-x86asm
    --enable-ffnvcodec # Encoders using GPU
    --enable-cuda
    --enable-cuvid
    --enable-nvenc
)

set(INSTALL_ROOT "INSTALL_ROOT=${INSTALL_PREFIX_ffmpeg}")

# script compiling the nvidia/ffmpeg headers
configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/scripts/nv-codec-headers-linux.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/scripts/nv-codec-headers-linux.cmake
    IMMEDIATE @ONLY
)

ExternalProject_Add(
    ffmpeg
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    URL_HASH SHA256=${FFMPEG_HASHSUM}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${FFMPEG_CONFIGURE_CMD}
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} -f Makefile ${INSTALL_ROOT} install
)

ExternalProject_Add_Step(ffmpeg COPY_FILES
    COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_ffmpeg} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.cmake
    DEPENDEES install
)

# headers compilation command, just before we build ffmpeg.
ExternalProject_Add_Step(ffmpeg nv-codec-headers
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/scripts/nv-codec-headers-linux.cmake
    DEPENDEES download
    DEPENDERS build
    COMMENT "Download & build nv-codec-headers"
)
