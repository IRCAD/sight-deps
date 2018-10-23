cmake_minimum_required(VERSION 3.0)

project(ffmpegBuilder)

include(ExternalProject)

if(WIN32)
    include(ffmpeg-win32.cmake)
elseif(APPLE)
    message("ffmpeg is only supported on Windows & Linux for the meantime...")
elseif(UNIX)
    include(ffmpeg-linux.cmake)
else()
endif()
