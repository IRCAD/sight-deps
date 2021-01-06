cmake_minimum_required(VERSION 3.0)

project(BinPkgs)


#looking for patch command
include( ${CMAKE_SOURCE_DIR}/cmake/utils/patch.cmake)
include( ${CMAKE_SOURCE_DIR}/cmake/utils/find_sse.cmake)
include( ${CMAKE_SOURCE_DIR}/cmake/install/install.cmake)
include( CMakeDependentOption )

# Build with SSE support if possible
fwFindSSE()

option(ENABLE_SSE_SUPPORT "Use SSE/SSE2/SSE3/SSE4 if available" ON)

if(ENABLE_SSE_SUPPORT)
    # Build with SSE support if possible
    fwFindSSE()

    set(CMAKE_C_FLAGS "${SSE_DEFINITIONS} ${CMAKE_C_FLAGS} ${SSE_FLAGS}")
    set(CMAKE_CXX_FLAGS "${SSE_DEFINITIONS} ${CMAKE_CXX_FLAGS} ${SSE_FLAGS} ")
endif()

set(COMMON_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
                      -DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}
                      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                      -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
                      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
                      -DCMAKE_LINKER=${CMAKE_LINKER}
                      -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
                      -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
)

if(NOT WIN32 AND NOT APPLE)
    set(SET_COMPILER_ENV export CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} &&)
endif()


if( ANDROID )
    set(CROSS_COMPILING ON CACHE BOOL "Cross compilation option")
else()
    set(CROSS_COMPILING OFF CACHE BOOL "Cross compilation option")
endif()

if(CROSS_COMPILING)
    if(NOT CMAKE_TOOLCHAIN_FILE)
        execute_process(COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/android/clean_all.cmake)
        set(CMAKE_TOOLCHAIN_FILE CACHE FILEPATH "Path to the toolchain file")
    endif()
    list(APPEND COMMON_CMAKE_ARGS -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
                                  -DANDROID_ABI=${ANDROID_ABI}
                                  -DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL})
endif()

set(ARCHIVE_DIR ${CMAKE_SOURCE_DIR}/archive CACHE PATH "Archive directory")

#Debug/Release
set(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel")
set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug;Release;RelWithDebInfo;MinSizeRel")

if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug" AND NOT CMAKE_BUILD_TYPE STREQUAL "Release" AND NOT CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo" AND NOT CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
    message(SEND_ERROR "Invalid value for CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE} (required Debug, Release, RelWithDebInfo or MinSizeRel)")
endif()
if(CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_CONFIGURATION_TYPES ${CMAKE_BUILD_TYPE} CACHE STRING "List of supported configurations." FORCE)
endif()

set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/${CMAKE_BUILD_TYPE}" CACHE PATH "Install directory")

# estimate the processor cout
include(ProcessorCount)
ProcessorCount(CPUS_COUNT)
if(CPUS_COUNT EQUAL 0)
    # default to 1 if cmake fails
    set(CPUS_COUNT 1)
endif()

mark_as_advanced(NUMBER_OF_PARALLEL_BUILD)
set(NUMBER_OF_PARALLEL_BUILD ${CPUS_COUNT} CACHE STRING "Number of parallel build for non-make based subprojects (Boost for instance)")

if(WIN32 OR CMAKE_HOST_WIN32 )
    set(MAKE nmake)
else()
    if(${CMAKE_GENERATOR} STREQUAL "Ninja")
        # We can not use '$(MAKE)' with Ninja
        set(MAKE make -j${NUMBER_OF_PARALLEL_BUILD})
    else()
        # This important to use '$(MAKE)' and not just 'make' to forward the flags from the command line (-j for instance)
        set(MAKE $(MAKE))
    endif()
    if(NOT APPLE)
        # Do not set the runtime path in the install step, this allows to get "portable" libraries
        list(APPEND COMMON_CMAKE_ARGS
            -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON
            -DCMAKE_SKIP_INSTALL_RPATH:BOOL=ON
        )
    else()
        list(APPEND COMMON_CMAKE_ARGS
            -DCMAKE_MACOSX_RPATH:BOOL=ON
        )
    endif()
endif()

option(ENABLE_CUDA "Set to ON to build packages with CUDA support (OpenCV, PCL, libSGM)" OFF)

## CUDA stuff
if(ENABLE_CUDA)
    set(BINPKGS_CUDA_ARCHS "3.0 3.5 3.7 5.0 5.2 6.0 6.1" CACHE STRING "CUDA architectures to build fw4spl dependencies for.")
    find_package(CUDA REQUIRED)
    # Strip any quotes from the CUDA toolkit directory if manually specified
    string(REPLACE "\"" "" CUDA_TOOLKIT_ROOT_DIR ${CUDA_TOOLKIT_ROOT_DIR})
endif()


#list(APPEND SUBDIRECTORIES pcl)
list(APPEND SUBDIRECTORIES dbow2)
list(APPEND SUBDIRECTORIES g2o)
list(APPEND SUBDIRECTORIES pangolin)
list(APPEND SUBDIRECTORIES openvslam)


macro(createUninstallTarget SUBDIR )

    # define an uninstall target for each project
    configure_file(
        "${CMAKE_SOURCE_DIR}/cmake_uninstall.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${SUBDIR}_uninstall.dir/${SUBDIR}_uninstall.cmake"
        IMMEDIATE @ONLY)

    add_custom_target(${SUBDIR}_uninstall
        COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${SUBDIR}_uninstall.dir/${SUBDIR}_uninstall.cmake)

    # define the standard location for the intermediate install directory
    set(INSTALL_PREFIX_${SUBDIR} ${CMAKE_CURRENT_BINARY_DIR}/${SUBDIR}/${SUBDIR}-prefix/src/${SUBDIR}-install-tmp)

endmacro()

macro(createCleanTarget SUBDIR )

    configure_file(
        "${CMAKE_SOURCE_DIR}/cmake_clean.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${SUBDIR}_clean.dir/${SUBDIR}_clean.cmake"
        IMMEDIATE @ONLY)

    add_custom_target(${SUBDIR}_clean
        COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${SUBDIR}_clean.dir/${SUBDIR}_clean.cmake)
    add_dependencies(${SUBDIR}_clean ${SUBDIR}_uninstall)

endmacro()

foreach(subdir ${SUBDIRECTORIES})

    # define an uninstall target for each project
    createUninstallTarget(${subdir})

    # define a clean target for each project
    createCleanTarget(${subdir})

    add_subdirectory(${subdir})

endforeach()

set(SUBDIRECTORIES "")

# Automatic detection of additional repositories using .sight-deps files
file(GLOB ADDITIONAL_REPOSITORIES_FILES ${CMAKE_CURRENT_SOURCE_DIR}/../*/.sight-deps)

foreach(REPOSITORY ${ADDITIONAL_REPOSITORIES_FILES})
    file(READ ${REPOSITORY} REPO_RAW_NAME)
    string(STRIP ${REPO_RAW_NAME} REPO_RAW_NAME)
    string(TOUPPER ${REPO_RAW_NAME} REPO_NAME)

    if(NOT ${REPO_NAME} STREQUAL "SIGHT-DEPS")

        get_filename_component(REPO_DIR ${REPOSITORY} DIRECTORY)
        get_filename_component(REPO_DIR ${REPO_DIR} ABSOLUTE)

        option(BUILD_${REPO_NAME} "Enable ${REPO_NAME} repository" ON)
        list(APPEND ADDITIONAL_REPOSITORIES_OPTION BUILD_${REPO_NAME})
        list(APPEND ADDITIONAL_REPOSITORIES_NAME ${REPO_RAW_NAME})
        list(APPEND ADDITIONAL_REPOSITORIES ${REPO_DIR})
    endif()
endforeach()

# parse additional CMakeLists
if(ADDITIONAL_REPOSITORIES)
    list(LENGTH ADDITIONAL_REPOSITORIES ADDITIONAL_REPOSITORIES_LEN)

    math(EXPR ADDITIONAL_REPOSITORIES_LEN ${ADDITIONAL_REPOSITORIES_LEN}-1)
    foreach(REPO_INDEX RANGE ${ADDITIONAL_REPOSITORIES_LEN})
        list(GET ADDITIONAL_REPOSITORIES ${REPO_INDEX} ADDITIONAL_REPO)
        list(GET ADDITIONAL_REPOSITORIES_OPTION ${REPO_INDEX} ADDITIONAL_REPO_OPTION)

        if(EXISTS ${ADDITIONAL_REPO}/CMakeLists.txt AND ${ADDITIONAL_REPO_OPTION})
            get_filename_component(DIR_NAME ${ADDITIONAL_REPO} NAME)
            add_subdirectory(${ADDITIONAL_REPO} ${CMAKE_BINARY_DIR}/additional_deps/${DIR_NAME})
        endif()
    endforeach()

endif()

####################################################################################################################
#. Find PYTHON - required for our build process
#
# if we are building for Android, we should not use CMAKE_FIND_ROOT_PATH when finding a program
# so we disable it temporarily, and we will reset it after find_program
if( ANDROID )
    set( TMP_PREVIOUS_CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ${CMAKE_FIND_ROOT_PATH_MODE_PROGRAM})
    set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER )
endif()

find_program(PYTHON_EXECUTABLE python ${PATH})

# if we are building for Android, now we have to reset CMAKE_FIND_ROOT_PATH_MODE_PROGRAM
if( ANDROID )
    set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ${TMP_PREVIOUS_CMAKE_FIND_ROOT_PATH_MODE_PROGRAM} )
endif()

####################################################################################################################
#. Install
if(APPLE)
    add_custom_target(install_tool
        COMMAND find . -name '*.dylib' -o -name '*.framework' | xargs ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/cmake/OSXTools/osx_install_name_tool.py –-progress -a -f -u -p
        WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}
    )
endif()

add_custom_target(fix_path
    COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/cmake/utils/fix_path.py "${CMAKE_INSTALL_PREFIX}"
    WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}
)

# Install the configuration file
configure_file(cmake/config/BinPkgsConfig.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/BinPkgsConfig.cmake)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/BinPkgsConfig.cmake cmake/utils/find_sse.cmake
        DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/cmake)

####################################################################################################################
# CPack related code
install(CODE "set(HOST_INSTALL_PATH \"${CMAKE_INSTALL_PREFIX}\")")
install(SCRIPT "${CMAKE_SOURCE_DIR}/cmake/utils/cpack_install.cmake")
install(SCRIPT "${CMAKE_SOURCE_DIR}/cmake/utils/fix_path.cmake")

include(${CMAKE_SOURCE_DIR}/cmake/utils/get_git_rev.cmake)
set(CPACK_PACKAGE_VERSION_MAJOR ${GIT_TAG_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${GIT_TAG_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${GIT_TAG_PATCH})
set(CPACK_PACKAGE_NAME ${PROJECT_NAME}-${CMAKE_BUILD_TYPE})
set(CPACK_PACKAGE_VENDOR "IRCAD/IHU")
set(CPACK_GENERATOR "TGZ")

include(CPack)
