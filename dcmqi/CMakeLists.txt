cmake_minimum_required(VERSION 3.0)

project(dcmqiBuilder)

include(ExternalProject)

set(DCMQI_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                    -DBUILD_SHARED_LIBS:BOOL=ON
                    -DDCMQI_BUILD_APPS:BOOL=OFF
                    -DDCMQI_BUILD_DOC:BOOL=OFF
                    -DDCMQI_BUILD_SLICER_EXTENSION:BOOL=OFF
                    -DDCMQI_SUPERBUILD:BOOL=OFF
                    -DBUILD_TESTING:BOOL=OFF
                    -DDCMTK_DIR:PATH=${CMAKE_INSTALL_PREFIX}/cmake
                    -DZLIB_ROOT:PATH=${CMAKE_INSTALL_PREFIX}
                    -DSlicerExecutionModel_DIR_CONFIG:PATH=${CMAKE_INSTALL_PREFIX}
)

set(CACHED_URL https://github.com/QIICR/dcmqi/archive/v1.1.0.tar.gz)

ExternalProject_Add(
    dcmqi
    GIT_REPOSITORY https://github.com/QIICR/dcmqi.git
    GIT_TAG v1.1.0
    DEPENDS dcmtk itk
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${DCMQI_CMAKE_ARGS}
)


