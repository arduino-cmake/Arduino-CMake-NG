include(PlatformElementsManager)
include(PropertiesReader)
include(BoardPropertiesReader)
include(PlatformFlagsSetter)

function(find_required_platform_elements)

    find_platform_cores()
    find_platform_variants()
    find_platform_bootloaders()
    find_platform_programmers()
    find_platform_properties_file()
    find_platform_boards()
    find_platform_libraries()
    if (NOT USE_CUSTOM_PLATFORM_HEADER)
        find_platform_main_header()
    endif ()

endfunction()

#=============================================================================#
# Initializes platform-related properties by parsing all property files.
#=============================================================================#
function(initialize_platform_properties)

    read_properties_from_file(${ARDUINO_CMAKE_PLATFORM_PROPERTIES_FILE_PATH})
    read_properties_from_file(${ARDUINO_CMAKE_PLATFORM_PROGRAMMERS_PATH})
    read_boards_properties(${ARDUINO_CMAKE_PLATFORM_BOARDS_PATH})

endfunction()

#=============================================================================#
# Initializes the Arduino-platform by defining the platform's path,
# parsing property files and setupping any remaining flags.
#=============================================================================#
function(initialize_arduino_platform)

    if (NOT DEFINED ARDUINO_CMAKE_PLATFORM_NAME OR NOT DEFINED ARDUINO_CMAKE_PLATFORM_PATH)
        if (USE_DEFAULT_PLATFORM_IF_NONE_EXISTING)
            if (CMAKE_HOST_ARCHLINUX AND ${USE_ARCHLINUX_BUILTIN_SUPPORT})
                set(ARDUINO_CMAKE_PLATFORM_NAME "archlinux-arduino" CACHE STRING "")
            else ()
                set(ARDUINO_CMAKE_PLATFORM_NAME "arduino" CACHE STRING "")
            endif ()
            set(ARDUINO_CMAKE_PLATFORM_ARCHITECTURE "avr" CACHE STRING "")
            string(CONCAT platform_path "${ARDUINO_SDK_PATH}"
                    /hardware/
                    "${ARDUINO_CMAKE_PLATFORM_NAME}/"
                    "${ARDUINO_CMAKE_PLATFORM_ARCHITECTURE}")
            set(ARDUINO_CMAKE_PLATFORM_PATH "${platform_path}" CACHE PATH "")
        else ()
            message(FATAL_ERROR "Arduino Platform must be defined through name and path")
        endif ()
    elseif (NOT DEFINED ARDUINO_CMAKE_PLATFORM_ARCHITECTURE) # Platform defined without architecture
        set(ARDUINO_CMAKE_PLATFORM_ARCHITECTURE "avr" CACHE STRING "")
    endif ()

    # Find all platform elements
    find_required_platform_elements()
    initialize_platform_properties()
    setup_remaining_platform_flags()

endfunction()
