#FFMPEG CMake script for windows

# specific version containing cuda options enable 
# DO NOT CHANGE WITHOUTH CHECKING FIRST!!
set(URL https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-20181212-32601fb-win64-static.zip)
set(FFMPEG_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/ffmpeg-prefix/src/ffmpeg)

ExternalProject_Add(
    ffmpeg
    URL ${URL}
    URL_HASH SHA256=3d2c126e49239a120b218b8530091fd4d74837cce136f24d6ef8b09bffd86816
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    CONFIGURE_COMMAND echo "Nothing to configure..."
    BUILD_COMMAND echo "Nothing to build..."
    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory "${FFMPEG_SRC_DIR}/bin" "${INSTALL_PREFIX_ffmpeg}/bin"
)

ExternalProject_Add_Step(ffmpeg COPY_FILES
    COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_ffmpeg} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.cmake
    DEPENDEES install
)
