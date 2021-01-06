cmake_minimum_required(VERSION 3.0)

project(g2oBuilder)

include(ExternalProject)


set(G2O_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                           -DBUILD_SHARED_LIBS:BOOL=ON
                           -DBUILD_LGPL_SHARED_LIBS:BOOL=ON
                           -DG2O_BUILD_EXAMPLES:BOOL=OFF
                           -DG2O_USE_OPENGL:BOOL=OFF
                           -DG2O_USE_CHOLMOD:BOOL=OFF
)

set(CACHED_URL https://github.com/IRCAD-IHU/g2o/archive/b5868094345dc4cd23a87ce7cf869aa0c528c60d.zip)

ExternalProject_Add(
    g2o
    URL ${CACHED_URL}
    URL_HASH SHA256=c2da80de313887d792f6c6537ad75d8b033fd655964b79cf18ec01e0febdf645
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME g2o.tar.gz
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${G2O_CMAKE_ARGS}
)