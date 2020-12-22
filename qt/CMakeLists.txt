cmake_minimum_required(VERSION 3.0)

project(qtBuilder)

include(ExternalProject)

set(QT5_URL "http://download.qt.io/archive/qt/5.14/5.14.2//single/qt-everywhere-src-5.14.2.tar.xz")
set(QT5_HASHSUM b3d2b6d00e6ca8a8ede6d1c9bdc74daf)

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
    -skip qtcanvas3d
    -skip qtcharts
    -skip qtconnectivity
    -skip qtdatavis3d
    -skip qtdoc
    -skip qtgamepad
    -skip qtimageformats
    -skip qtlocation
    -skip qtpurchasing
    -skip qtremoteobjects
    -skip qtscript
    -skip qtscxml
    -skip qtsensors
    -skip qtserialbus
    -skip qtserialport
    -skip qtspeech
    -skip qttranslations
    -skip qtwayland
    -skip qtwebchannel
    -skip qtwebengine
    -skip qtwebsockets
    -skip qtwebview
    -skip qtxmlpatterns)

if(WIN32)
    include(qt_windows.cmake)
elseif(UNIX)
    include(qt_linux.cmake)
else()
    message(SEND_ERROR "Unknown plateform.")
endif()
