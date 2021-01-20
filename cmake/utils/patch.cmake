cmake_minimum_required(VERSION 3.0)

if(NOT PATCH_EXECUTABLE)

    message(STATUS "Checking for patch...")
     
    find_program(PATCH_EXECUTABLE 
        NAMES patch patch.exe
        PATHS "usr/bin"
    )
    
    if(NOT PATCH_EXECUTABLE)
        message(FATAL_ERROR "ABORT : Patch not found.")
    endif()
    
    message(STATUS "SUCCESS : Found patch ${PATCH_EXECUTABLE}.")

    set(PATCH_EXECUTABLE ${PATCH_EXECUTABLE} CACHE FILEPATH "Patch executable" FORCE )
endif()


macro(patch_file baseDir patchFile)
    execute_process(COMMAND ${PATCH_EXECUTABLE} -p1 -i "${patchFile}"
                    WORKING_DIRECTORY "${baseDir}")
endmacro()
