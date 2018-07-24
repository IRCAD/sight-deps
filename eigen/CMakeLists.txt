cmake_minimum_required(VERSION 3.0)

project(eigenBuilder)

include(ExternalProject)

set(EIGEN3_VERSION "f7a834787700c75ca98e690804d5382dc71d7d39")
set(CACHED_URL https://github.com/eigenteam/eigen-git-mirror/archive/${EIGEN3_VERSION}.tar.gz)

set(EIGEN_CMAKE_ARGS    ${COMMON_CMAKE_ARGS}
                        -DBUILD_SHARED_LIBS:BOOL=ON
                        -DEIGEN_TEST_NOQT:BOOL=ON
                        -DBUILD_TESTING:BOOL=OFF
)

if(ANDROID)
    list(APPEND EIGEN_CMAKE_ARGS
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
        -DBUILD_TESTING:BOOL=OFF
    )
endif()

set(EIGEN_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/eigen-prefix/src/eigen)

ExternalProject_Add(
    eigen
    URL ${CACHED_URL}
    URL_HASH SHA256=64f5faf397d0fd02fc2eba467331086e591e619a2af3268e52e35cfab3da501f
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME "eigen_${EIGEN3_VERSION}.tar.gz"
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${EIGEN_CMAKE_ARGS}
)

fwInstallFile(
    BINPKG eigen
    SRC ${CMAKE_CURRENT_BINARY_DIR}/eigen-prefix/src/eigen/cmake/FindEigen3.cmake
    DEST ${CMAKE_INSTALL_PREFIX}/FindEigen.cmake
)
