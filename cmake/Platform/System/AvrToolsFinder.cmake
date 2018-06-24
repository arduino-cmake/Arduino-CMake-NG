#=============================================================================#
# Finds 'avr-objcopy' tool in Arduino's SDK path.
#=============================================================================#
function(find_tool_avr_objcopy)

    find_program(ARDUINO_CMAKE_AVROBJCOPY_PROGRAM
            NAMES avr-objcopy
            PATHS ${ARDUINO_SDK_BIN_PATH}
            DOC "Path to avr's objcopy program")
    if (NOT ARDUINO_CMAKE_AVROBJCOPY_PROGRAM OR ${ARDUINO_CMAKE_AVROBJCOPY_PROGRAM} STREQUAL "")
        message(FATAL_ERROR "avr-objcopy program is required by the toolchain but can't be found")
    endif ()
    set(CMAKE_OBJCOPY ${ARDUINO_CMAKE_AVROBJCOPY_PROGRAM})

endfunction()

#=============================================================================#
# Finds 'avrdude' tool in Arduino's SDK path.
#=============================================================================#
function(find_tool_avrdude)

    find_program(ARDUINO_CMAKE_AVRDUDE_PROGRAM
            NAMES avrdude
            PATHS ${ARDUINO_SDK_BIN_PATH}
            DOC "Path to avrdude program (Code Uploader)")
    if (NOT ARDUINO_CMAKE_AVRDUDE_PROGRAM OR ${ARDUINO_CMAKE_AVRDUDE_PROGRAM} STREQUAL "")
        message(FATAL_ERROR "avrdude program is required by the toolchain but can't be found")
    endif ()

endfunction()

#=============================================================================#
# Finds 'avrdude' tool's configuration file in Arduino's SDK path.
#=============================================================================#
function(find_tool_avrdude_configuration)

    find_file(ARDUINO_CMAKE_AVRDUDE_CONFIG_PATH
            NAMES avrdude.conf
            PATHS ${ARDUINO_SDK_ROOT_PATH}
            PATH_SUFFIXES /etc /etc/avrdude
            DOC "Path to avrdude's programmer configuration file")
    if (NOT ARDUINO_CMAKE_AVRDUDE_CONFIG_PATH OR ${ARDUINO_CMAKE_AVRDUDE_CONFIG_PATH} STREQUAL "")
        message(FATAL_ERROR "avrdude program is required by the toolchain but can't be found")
    endif ()

endfunction()

#=============================================================================#
# Finds 'avr-size' tool in Arduino's SDK path.
#=============================================================================#
function(find_tool_avrsize)

    find_program(ARDUINO_CMAKE_AVRSIZE_PROGRAM
            NAMES avr-size
            PATHS ${ARDUINO_SDK_BIN_PATH}
            DOC "Path to avr-size program (Size Calculator)")
    if (NOT ARDUINO_CMAKE_AVRSIZE_PROGRAM OR ${ARDUINO_CMAKE_AVRSIZE_PROGRAM} STREQUAL "")
        message(FATAL_ERROR "avrdude program is required by the toolchain but can't be found")
    endif ()

endfunction()
