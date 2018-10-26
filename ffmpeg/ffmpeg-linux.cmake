#FFMPEG CMake script for Linux

set(FFMPEG_URL "https://ffmpeg.org/releases/ffmpeg-4.0.tar.gz")
set(FFMPEG_HASHSUM dc4b1c622baa34fc68d763cd2818e419d1af90271e0506604905f25a46ea8273)

set(CACHED_URL ${FFMPEG_URL})

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

message("${FFMPEG_CONFIGURE_CMD}")

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

