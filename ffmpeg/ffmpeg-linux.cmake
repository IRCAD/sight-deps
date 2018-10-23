#FFMPEG CMake script for Linux

set(FFMPEG_URL "https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2")
set(FFMPEG_HASHSUM 8c32191ce4c690175dfaccce8aefccc9794fae3dd1fff2013f00c15794e2d2ec)

set(CACHED_URL ${FFMPEG_URL})

set(FFMPEG_CONFIGURE_CMD
     PKG_CONFIG_PATH=${CMAKE_INSTALL_PREFIX}/lib/pkgconfig ./configure
    --prefix=${CMAKE_INSTALL_PREFIX}
    --enable-gpl
    --extra-cflags="-I${CMAKE_INSTALL_PREFIX}/include"
    --extra-ldflags="-L${CMAKE_INSTALL_PREFIX}/lib"
    --enable-libx264
    --enable-libx265
    --disable-x86asm
    --enable-ffnvcodec
    --enable-cuda
    --enable-cuvid
    --enable-nvenc
)



message("${FFMPEG_CONFIGURE_CMD}")

set(INSTALL_ROOT "INSTALL_ROOT=${INSTALL_PREFIX_ffmpeg}")


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



ExternalProject_Add_Step(ffmpeg nv-codec-headers
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/scripts/nv-codec-headers-linux.cmake
    DEPENDEES download
    DEPENDERS build
    COMMENT "Download & build nv-codec-headers"
)

