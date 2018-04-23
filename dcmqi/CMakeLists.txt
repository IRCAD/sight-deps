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
                    -DDCMQI_BUILTIN_JSONCPP:BOOL=OFF
                    -DDCMTK_DIR:PATH=${CMAKE_INSTALL_PREFIX}/cmake
                    -DSlicerExecutionModel_DIR_CONFIG:PATH=${CMAKE_INSTALL_PREFIX}
)

set(DCMQI_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(DCMQI_PATCH_CMD ${PATCH_EXECUTABLE} -p1 -i ${DCMQI_PATCH_DIR}/install_target.patch -d <SOURCE_DIR>)
set(CACHED_URL https://github.com/QIICR/dcmqi/archive/v1.1.0.tar.gz)

ExternalProject_Add(
    dcmqi
    GIT_REPOSITORY https://github.com/QIICR/dcmqi.git
    GIT_TAG v1.1.0
    DEPENDS dcmtk itk jsoncpp
    PATCH_COMMAND ${DCMQI_PATCH_CMD}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${DCMQI_CMAKE_ARGS}
)


