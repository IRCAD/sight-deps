cmake_minimum_required(VERSION 3.0)

project(libSGMBuilder)

find_package(CUDA REQUIRED)

include(ExternalProject)

set(CACHED_URL https://github.com/fw4spl-org/libSGM/archive/93e2df1404e840aed39930d1088a683339040b6e.tar.gz)

include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )


# Select the correct CUDA flags for the supported architectures 
if(BINPKGS_CUDA_ARCHS) 
    CUDA_SELECT_NVCC_ARCH_FLAGS(ARCH_CUDA_FLAGS ${BINPKGS_CUDA_ARCHS}) 
else() 
    # No BinPkgs configuration file for whatever reason, just build for every arch under the sun. 
    CUDA_SELECT_NVCC_ARCH_FLAGS(ARCH_CUDA_FLAGS "All") 
endif() 

string (REPLACE ";" " " ARCH_CUDA_FLAGS_STR "${ARCH_CUDA_FLAGS}")

list(APPEND CUDA_NVCC_FLAGS ${ARCH_CUDA_FLAGS_STR})

set(libSGM_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                      -DCUDA_NVCC_FLAGS:STRING=${CUDA_NVCC_FLAGS}
                      -DCUDA_HOST_COMPILER:STRING=${CUDA_HOST_COMPILER}
                      -DCUDA_TOOLKIT_ROOT_DIR:PATH=${CUDA_TOOLKIT_ROOT_DIR}
                      -DLIBSGM_SHARED:BOOL=ON
)

if(UNIX)
    list(APPEND libSGM_CMAKE_ARGS -DCUDA_PROPAGATE_HOST_FLAGS:BOOL=OFF)
else()
    list(APPEND libSGM_CMAKE_ARGS -DCUDA_PROPAGATE_HOST_FLAGS:BOOL=ON)
endif()

if(WIN32)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /FS")
    list(APPEND libSGM_CMAKE_ARGS -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS})
endif()

ExternalProject_Add(
    libSGM
    URL ${CACHED_URL}
    URL_HASH SHA256=51f13253fd5b7d12322031851f655217131c06827ee4cdb302b6f6115ee02573
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    INSTALL_DIR "${CMAKE_INSTALL_PREFIX}"
    CMAKE_ARGS ${libSGM_CMAKE_ARGS}
)
