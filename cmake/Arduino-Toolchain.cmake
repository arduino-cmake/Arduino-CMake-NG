include(${CMAKE_CURRENT_LIST_DIR}/Platform/Other/ArduinoSDKSeeker.cmake)

function(_find_required_programs)

    # Find ASM compiler
    find_program(CMAKE_ASM_COMPILER avr-gcc
            PATHS ${ARDUINO_SDK_BIN_PATH}
            NO_DEFAULT_PATH
            NO_CMAKE_FIND_ROOT_PATH)
    # Find C compiler
    find_program(CMAKE_C_COMPILER avr-gcc
            PATHS ${ARDUINO_SDK_BIN_PATH}
            NO_DEFAULT_PATH
            NO_CMAKE_FIND_ROOT_PATH)
    # Find C++ compiler
    find_program(CMAKE_CXX_COMPILER avr-g++
            PATHS ${ARDUINO_SDK_BIN_PATH}
            NO_DEFAULT_PATH
            NO_CMAKE_FIND_ROOT_PATH)
    # Find AR required for linkage
    find_program(CMAKE_AR avr-gcc-ar
            PATHS ${ARDUINO_SDK_BIN_PATH}
            NO_DEFAULT_PATH
            NO_CMAKE_FIND_ROOT_PATH)
    # Find Ranlib required for linkage
    find_program(CMAKE_RANLIB avr-gcc-ranlib
            PATHS ${ARDUINO_SDK_BIN_PATH}
            NO_DEFAULT_PATH
            NO_CMAKE_FIND_ROOT_PATH)
    # Find NM
    find_program(CMAKE_NM avr-gcc-nm
            PATHS ${ARDUINO_SDK_BIN_PATH}
            NO_DEFAULT_PATH
            NO_CMAKE_FIND_ROOT_PATH)

endfunction()

function(_setup_sdk_internal_paths)

    set(ARDUINO_SDK_BIN_PATH "${ARDUINO_SDK_PATH}/hardware/tools/avr/bin" CACHE PATH
            "Path to Arduino SDK's binaries folder")
    set(ARDUINO_SDK_ROOT_PATH "${ARDUINO_SDK_PATH}/hardware/tools/avr" CACHE PATH
            "Path to Arduino SDK's sys-root folder")
    set(ARDUINO_SDK_LIBRARIES_PATH "${ARDUINO_SDK_PATH}/libraries" CACHE PATH
            "Path to SDK's libraries directory")
    set(ARDUINO_SDK_EXAMPLES_PATH "${ARDUINO_SDK_PATH}/examples" CACHE PATH
            "Path to SDK's examples directory")

endfunction()

set(CMAKE_SYSTEM_NAME Arduino)

# Add current directory to CMake Module path automatically
if (EXISTS ${CMAKE_CURRENT_LIST_DIR}/Platform/Arduino.cmake)
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_LIST_DIR})
endif ()

set(ARDUINO_CMAKE_TOOLCHAIN_DIR ${CMAKE_CURRENT_LIST_DIR} CACHE PATH
        "Path to Arduino-CMake's toolchain directory")

if (DEFINED ENV{ARDUINO_SDK_PATH})
    string(REPLACE "\\" "/" unix_style_sdk_path $ENV{ARDUINO_SDK_PATH})
    set(ARDUINO_SDK_PATH "${unix_style_sdk_path}" CACHE PATH "Arduino SDK Path")
else ()
    # Set default path if none is set
    find_arduino_sdk(arduino_sdk_path)
    set(ARDUINO_SDK_PATH "${arduino_sdk_path}" CACHE PATH "Arduino SDK Path")
endif ()

_setup_sdk_internal_paths()
_find_required_programs()

# where is the target environment
set(CMAKE_FIND_ROOT_PATH "${ARDUINO_SDK_ROOT_PATH}")

# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
