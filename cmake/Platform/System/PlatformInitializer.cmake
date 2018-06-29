include(PlatformElementsFinder)
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
            set(ARDUINO_CMAKE_PLATFORM_NAME "arduino" CACHE STRING "")
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

    # Required by compiler recipes
    set(build_arch "${ARDUINO_CMAKE_PLATFORM_ARCHITECTURE}" CACHE STRING "")

    # Find all platform elements
    find_required_platform_elements()

    initialize_platform_properties()

    setup_remaining_platform_flags()

endfunction()
