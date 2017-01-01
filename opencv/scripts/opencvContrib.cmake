cmake_minimum_required(VERSION 3.0)

file(DOWNLOAD https://github.com/opencv/opencv_contrib/archive/3.2.0.tar.gz @CMAKE_CURRENT_BINARY_DIR@/opencv_contrib/opencv_contrib_3.2.0.tar.gz )
execute_process(
    COMMAND ${CMAKE_COMMAND} -E tar xzf opencv_contrib_3.2.0.tar.gz
    WORKING_DIRECTORY @CMAKE_CURRENT_BINARY_DIR@/opencv_contrib/
)

execute_process(
    COMMAND ${CMAKE_COMMAND} -E rename opencv_contrib-3.2.0/ src/
    WORKING_DIRECTORY @CMAKE_CURRENT_BINARY_DIR@/opencv_contrib/
)
