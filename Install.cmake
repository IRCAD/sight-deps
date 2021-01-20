macro(installWatchUnix TEMP_PATH INSTALL_PATH)
    set(TEMP_PATH ${TEMP_PATH}${INSTALL_PATH})

    # create the directory where the install_manifest.txt will be written
    string(FIND ${CMAKE_CURRENT_SOURCE_DIR} "/" SLASHPOS REVERSE)
    string(SUBSTRING ${CMAKE_CURRENT_SOURCE_DIR} ${SLASHPOS} -1 PROJECTNAME)
    set(BUILD_DIR "${CMAKE_CURRENT_SOURCE_DIR}${PROJECTNAME}-prefix/src${PROJECTNAME}-build")
    file(MAKE_DIRECTORY ${BUILD_DIR})

    # retrieve the list of files in the intermediate install path
    file(GLOB_RECURSE FILE_LIST "${TEMP_PATH}/*")

    # clean the old install_manifest.txt
    file(REMOVE "${BUILD_DIR}/install_manifest.txt")

    foreach(FILENAME IN LISTS FILE_LIST)
        # write the filename in the install_manifest.txt
        file(RELATIVE_PATH REL_FILENAME ${TEMP_PATH} ${FILENAME})
        file(TO_NATIVE_PATH "/${REL_FILENAME}" INSTALL_FILENAME)
        file(RELATIVE_PATH REL_FILENAME ${INSTALL_PATH} "/${REL_FILENAME}")
        file(APPEND "${BUILD_DIR}/install_manifest.txt" "${INSTALL_FILENAME}\n")

        # Copy the file at the final install place    
        string(FIND ${INSTALL_FILENAME} "/" SLASHPOS REVERSE)
        string(SUBSTRING  ${INSTALL_FILENAME} 0 ${SLASHPOS} INSTALL_DIR)
        file(INSTALL ${FILENAME} DESTINATION ${INSTALL_DIR} USE_SOURCE_PERMISSIONS)
    endforeach()

    file(REMOVE_RECURSE ${TEMP_PATH})
endmacro()

installWatchUnix(${SRC} ${DST})

