cmake_minimum_required(VERSION 3.0)

project(ffmpegBuilder)

include(ExternalProject)

if(WIN32)

    set(URL https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-20180306-a43e9cd-win64-static.zip)
    set(FFMPEG_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/ffmpeg-prefix/src/ffmpeg)

    ExternalProject_Add(
        ffmpeg
        URL ${URL}
        URL_HASH SHA256=51b8cb2528a54a5debbb4a55d2dc87caa3daf43a28c751ce17b2e4d00abd0606
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        CONFIGURE_COMMAND echo "Nothing to configure..."
        BUILD_COMMAND echo "Nothing to build..."
        INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory "${FFMPEG_SRC_DIR}/bin" "${INSTALL_PREFIX_ffmpeg}/bin"
        )
    ExternalProject_Add_Step(ffmpeg COPY_FILES
        COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_ffmpeg} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.cmake
        DEPENDEES install
    )
)
else()
    message("ffmpeg is only supported on Windows for the meantime...")
