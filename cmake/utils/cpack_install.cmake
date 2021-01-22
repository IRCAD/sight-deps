cmake_minimum_required(VERSION 3.0)

# Detects if the install is run by CPack and copies all SightDeps in CPack install folder
if (${CMAKE_INSTALL_PREFIX} MATCHES "/_CPack_Packages/.*/(TGZ|ZIP|TZST)/")
    file(COPY ${HOST_INSTALL_PATH}/ DESTINATION ${CMAKE_INSTALL_PREFIX} USE_SOURCE_PERMISSIONS)
endif()
