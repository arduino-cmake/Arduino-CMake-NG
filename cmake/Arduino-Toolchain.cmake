set(CMAKE_SYSTEM_NAME Arduino)

# Add current directory to CMake Module path automatically
if (EXISTS ${CMAKE_CURRENT_LIST_DIR}/Platform/Arduino.cmake)
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_LIST_DIR})
endif ()

set(ARDUINO_CMAKE_TOOLCHAIN_DIR ${CMAKE_CURRENT_LIST_DIR} CACHE PATH
        "Path to Arduino-CMake's toolchain directory")

# Set default path if none is set
if (NOT ARDUINO_SDK_PATH)
    if (${CMAKE_HOST_WIN32})
        set(ARDUINO_SDK_PATH "C:/Program Files (x86)/Arduino")
    endif ()
endif ()

set(ARDUINO_SDK_BIN_PATH "${ARDUINO_SDK_PATH}/hardware/tools/avr/bin" CACHE PATH
        "Path to Arduino SDK's binaries folder")
set(ARDUINO_SDK_ROOT_PATH "${ARDUINO_SDK_PATH}/hardware/tools/avr" CACHE PATH
        "Path to Aduino SDK's sys-root folder")

set(CMAKE_ASM_COMPILER "${ARDUINO_SDK_BIN_PATH}/avr-gcc")
set(CMAKE_C_COMPILER "${ARDUINO_SDK_BIN_PATH}/avr-gcc")
set(CMAKE_CXX_COMPILER "${ARDUINO_SDK_BIN_PATH}/avr-g++")
#[[set(CMAKE_AR "${ARDUINO_SDK_BIN_PATH}/avr-gcc-ar")
set(CMAKE_RANLIB "${ARDUINO_SDK_BIN_PATH}/avr-gcc-ranlib")]]

# Append '.exe' if in Windows
if (${CMAKE_HOST_WIN32})
    set(CMAKE_C_COMPILER "${CMAKE_C_COMPILER}.exe")
    set(CMAKE_CXX_COMPILER "${CMAKE_CXX_COMPILER}.exe")
    set(CMAKE_ASM_COMPILER "${CMAKE_ASM_COMPILER}.exe")
    #[[set(CMAKE_AR "${CMAKE_AR}.exe")
    set(CMAKE_RANLIB "${CMAKE_RANLIB}.exe")]]
endif ()

#[[set(CMAKE_C_ARCHIVE_CREATE "<CMAKE_AR> rcs <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_CXX_ARCHIVE_CREATE "<CMAKE_AR> rcs <TARGET> <LINK_FLAGS> <OBJECTS>")]]

# where is the target environment
set(CMAKE_FIND_ROOT_PATH "${ARDUINO_SDK_ROOT_PATH}")

# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
