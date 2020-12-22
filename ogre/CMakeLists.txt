cmake_minimum_required(VERSION 3.0)

project(ogre)

include(ExternalProject)

set(CACHED_URL https://github.com/OGRECave/ogre/archive/v1.12.9.zip)
set(OGRE_HASH 9150ff2b7a8b6a79ad2a61586006617b3d4939b839572f00315664976335d69a)

include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )

set(OGRE_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                    -DBUILD_SHARED_LIBS:BOOL=ON
                    -DOGRE_BUILD_SAMPLES:BOOL=OFF
                    -DOGRE_INSTALL_SAMPLES:BOOL=OFF
                    -DOGRE_INSTALL_SAMPLES_SOURCE:BOOL=OFF
                    -DOGRE_BUILD_TESTS:BOOL=OFF
                    -DOGRE_BUILD_TOOLS:BOOL=OFF
                    -DOGRE_BUILD_RENDERSYSTEM_GL:BOOL=OFF
                    -DOGRE_BUILD_RENDERSYSTEM_GLES2:BOOL=OFF
                    -DOGRE_BUILD_RENDERSYSTEM_GL3PLUS:BOOL=ON
                    -DOGRE_BUILD_RENDERSYSTEM_D3D9:BOOL=OFF
                    -DOGRE_BUILD_RENDERSYSTEM_D3D11:BOOL=OFF
                    -DOGRE_INSTALL_DOCS:BOOL=OFF
                    -DOGRE_BUILD_PLUGIN_BSP:BOOL=OFF
                    -DOGRE_BUILD_PLUGIN_CG:BOOL=OFF
                    -DOGRE_BUILD_PLUGIN_FREEIMAGE:BOOL=OFF
                    -DOGRE_BUILD_PLUGIN_OCTREE:BOOL=OFF
                    -DOGRE_BUILD_PLUGIN_PCZ:BOOL=OFF
                    -DOGRE_BUILD_PLUGIN_PFX:BOOL=OFF
                    -DOGRE_BUILD_PLUGIN_DOT_SCENE:BOOL=OFF
                    -DOGRE_BUILD_PLUGIN_STBI:BOOL=OFF
                    -DOGRE_BUILD_DEPENDENCIES:BOOL=OFF
                    -DOGRE_INSTALL_DEPENDENCIES:BOOL=OFF
                    -DOGRE_CONFIG_ENABLE_ZIP:BOOL=ON
                    -DOGRE_BUILD_PLATFORM_APPLE_IOS:BOOL=OFF
                    -DOGRE_BUILD_COMPONENT_HLMS:BOOL=OFF
                    -DOGRE_BUILD_COMPONENT_TERRAIN:BOOL=OFF
                    -DOGRE_BUILD_COMPONENT_RTSHADERSYSTEM:BOOL=OFF
                    -DOGRE_BUILD_COMPONENT_VOLUME:BOOL=OFF
                    -DOGRE_BUILD_COMPONENT_BITES:BOOL=OFF
                    -DOGRE_BUILD_COMPONENT_PYTHON:BOOL=OFF
                    -DOGRE_CONFIG_THREAD_PROVIDER:STRING=std
                    -DOGRE_BUILD_LIBS_AS_FRAMEWORKS=OFF # No, we don't want framework, even on macOS
                    -DOGRE_RESOURCEMANAGER_STRICT=0 # Use the (slow) legacy mode otherwise our apps break
   )

if(WIN32)
    set(OGRE_CMAKE_ARGS ${OGRE_CMAKE_ARGS} -DOGRE_INSTALL_PDB:BOOL=OFF)
endif()

ExternalProject_Add(
    ogre
    URL ${CACHED_URL}
    URL_HASH SHA256=${OGRE_HASH}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME ogre-1.12.9.zip
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${OGRE_CMAKE_ARGS}
)

