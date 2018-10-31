cmake_minimum_required(VERSION 3.0)

project(ffmpegBuilder)

include(ExternalProject)

# On windows, a redistrubable is downloaded while in linux we compile the whole thing.
if(WIN32)
    include(ffmpeg-win32.cmake)
elseif(APPLE)
    message("ffmpeg is only supported on Windows & Linux for the meantime...")
elseif(UNIX)
    include(ffmpeg-linux.cmake)
else()
endif()
