cmake_minimum_required(VERSION 3.0)

project(qtBuilder)

include(ExternalProject)

set(QT5_URL "http://download.qt.io/official_releases/qt/5.11/5.11.0/single/qt-everywhere-src-5.11.0.tar.xz")
set(QT5_HASHSUM 67ddb8bf33bbfd19ebc641467ccce2e57fd0b80c6082457f1f5a76e8df83c865)

set(CACHED_URL ${QT5_URL})

if(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
    set(QT_BUILD_TYPE debug)
elseif(${CMAKE_BUILD_TYPE} STREQUAL "RelWithDebInfo")
    set(QT_BUILD_TYPE release -force-debug-info)
else()
    set(QT_BUILD_TYPE release)
endif()

set(QT_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(QT_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/qt-prefix/src/qt)

set(QT_SKIP_MODULES_LIST
    -skip qtactiveqt
    -skip qtconnectivity
    -skip qtsensors
    -skip qttranslations
    -skip qtwayland
    -skip qtwebchannel
    -skip qtwebsockets
    -skip qtserialport
    -skip qtdoc
    -skip qtlocation)

if(WIN32)
    include(qt_windows.cmake)
elseif(APPLE)
    include(qt_apple.cmake)
elseif(ANDROID)
    include(qt_android.cmake)
elseif(UNIX)
    include(qt_linux.cmake)
else()
    message(SEND_ERROR "Unknown plateform.")
endif()

if(APPLE)
    ExternalProject_Add_Step(qt FRAMEWORK_FIXUP
        COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/OSXTools/osx_qt_symbolic_link.py
        WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}
        DEPENDEES COPY_FILES
     )
endif()

fwInstallFile(
    BINPKG qt
    SRC ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-Qt5.cmake
    DEST ${CMAKE_INSTALL_PREFIX}/fw-Qt5.cmake
)

fwInstallDir(
    BINPKG qt
    SRC ${CMAKE_CURRENT_SOURCE_DIR}/fonts
    DEST ${CMAKE_INSTALL_PREFIX}/lib/fonts
)
