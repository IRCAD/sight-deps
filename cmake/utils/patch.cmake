cmake_minimum_required(VERSION 3.0)

if(NOT PATCH_EXECUTABLE)

    message(STATUS "Checking for patch...")
    
    
    # if we are building for Android, we should not use CMAKE_FIND_ROOT_PATH when finding a program
    # so we disable it temporarily, and we will reset it after find_program
    if( ANDROID )
        set( TMP_PREVIOUS_CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ${CMAKE_FIND_ROOT_PATH_MODE_PROGRAM})
        set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER )
    endif()
    
    #necessary hack
    set(PRGM_FILES_X86 "ProgramFiles(x86)")
    
    find_program(PATCH_EXECUTABLE 
        NAMES patch patch.exe
        PATHS "usr/bin"
              "$ENV{ProgramW6432}/GnuWin32/bin"
              "$ENV{ProgramW6432}/Git/bin"
              "$ENV{ProgramW6432}/Git/usr/bin"
              "$ENV{${PRGM_FILES_X86}}/GnuWin32/bin"
              "$ENV{${PRGM_FILES_X86}}/Git/bin"
              "$ENV{${PRGM_FILES_X86}}/Git/usr/bin"
              "${CMAKE_BINARY_DIR}/patch/msysgit-Git-1.9.5-preview20150319/bin"
    )
    
    # if we are building for Android, now we have to
    # reset CMAKE_FIND_ROOT_PATH_MODE_PROGRAM
    if( ANDROID )
        set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ${TMP_PREVIOUS_CMAKE_FIND_ROOT_PATH_MODE_PROGRAM} )
    endif()  
    
    
    if(NOT PATCH_EXECUTABLE)
    
        message(STATUS "...not found in the given directories.")
        
        if(CMAKE_HOST_WIN32 OR WIN32)
        
            # make sure the patch does not exist, and that we missed it by error
            set(PATCH_EXE "${CMAKE_BINARY_DIR}/patch/usr/bin/patch.exe")
            if(NOT (EXISTS ${PATCH_EXE})) 
                #download git-patch for Windows
                message(STATUS "Downloading git-patch for Windows")
                set(PATCH_URL https://github.com/git-for-windows/git/releases/download/v2.19.0.windows.1/Git-2.19.0-64-bit.tar.bz2)
                file(DOWNLOAD ${PATCH_URL} ${CMAKE_BINARY_DIR}/patch/Git-2.19.0-64-bit.tar.bz2
                     SHOW_PROGRESS
                     EXPECTED_MD5 d1b59ab95ce6c8605770852181a52627
                     STATUS download_status)

                list(GET download_status 0 download_status_num)
                if(NOT (download_status_num EQUAL 0))
                    message(FATAL_ERROR "Can't download git patch")                
                endif()
                     
                #uncompressing 
                message(STATUS "Uncompressing git-patch for Windows")
                execute_process(COMMAND ${CMAKE_COMMAND} -E tar xvf Git-2.19.0-64-bit.tar.bz2
                                WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/patch/")
                                
                #checking it's really ok
                if(NOT EXISTS ${PATCH_EXE}) 
                    message(FATAL_ERROR "File ${PATCH_EXE} was still not found")                
                endif()
            endif()

            set(PATCH_EXECUTABLE ${PATCH_EXE})                   
            message(STATUS "Done")

        else()
            message(FATAL_ERROR "ABORT : Patch not found.")
        endif()
    endif()
    
    message(STATUS "SUCCESS : Found patch ${PATCH_EXECUTABLE}.")
    
    set(PATCH_EXECUTABLE ${PATCH_EXECUTABLE} CACHE FILEPATH "Patch executable" FORCE )
    
endif()


macro(patch_file baseDir patchFile)
    execute_process(COMMAND ${PATCH_EXECUTABLE} -p1 -i "${patchFile}"
                    WORKING_DIRECTORY "${baseDir}")
endmacro()
