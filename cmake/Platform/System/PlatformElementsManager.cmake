function(find_platform_cores)

    # Avoid searching system's PATH as the SDK's general `Libraries` directory 
    # may be used instead of the platform's directory
    find_file(ARDUINO_CMAKE_PLATFORM_CORES_PATH
            NAMES cores
            PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
            DOC "Path to directory containing the Platform's core sources"
            NO_SYSTEM_ENVIRONMENT_PATH
            NO_CMAKE_FIND_ROOT_PATH)

    set(core_list "")

    file(GLOB sub-dir ${ARDUINO_CMAKE_PLATFORM_CORES_PATH}/*)
    foreach (dir ${sub-dir})
        if (IS_DIRECTORY ${dir})
            get_filename_component(core ${dir} NAME)
            string(TOLOWER ${core} core)
            set(ARDUINO_CMAKE_CORE_${core}_PATH "${dir}" CACHE INTERNAL "Path to ${core} core")
            list(APPEND core_list ${core})
        endif ()
    endforeach ()

    set(ARDUINO_CMAKE_PLATFORM_CORES "${core_list}" CACHE STRING "List of existing platform cores")

endfunction()

function(find_platform_variants)

    # Avoid searching system's PATH as the SDK's general `Libraries` directory 
    # may be used instead of the platform's directory
    find_file(ARDUINO_CMAKE_PLATFORM_VARIANTS_PATH
            NAMES variants
            PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
            DOC "Path to directory containing the Platform's variant sources"
            NO_SYSTEM_ENVIRONMENT_PATH
            NO_CMAKE_FIND_ROOT_PATH)
    file(GLOB sub-dir ${ARDUINO_CMAKE_PLATFORM_VARIANTS_PATH}/*)

    set(variant_list "")

    foreach (dir ${sub-dir})
        if (IS_DIRECTORY ${dir})
            get_filename_component(variant ${dir} NAME)
            string(TOLOWER ${variant} variant)
            set(ARDUINO_CMAKE_VARIANT_${variant}_PATH ${dir} CACHE INTERNAL
                    "Path to ${variant} variant")
            list(APPEND variant_list ${variant})
        endif ()
    endforeach ()

    set(ARDUINO_CMAKE_PLATFORM_VARIANTS "${variant_list}" CACHE STRING
            "List of existing platform variants")

endfunction()

function(find_platform_bootloaders)

    # Avoid searching system's PATH as the SDK's general `Libraries` directory 
    # may be used instead of the platform's directory
    find_file(ARDUINO_CMAKE_PLATFORM_BOOTLOADERS_PATH
            NAMES bootloaders
            PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
            DOC "Path to directory containing the Platform's bootloader images and sources"
            NO_SYSTEM_ENVIRONMENT_PATH
            NO_CMAKE_FIND_ROOT_PATH)

endfunction()

function(find_platform_programmers)

    # Avoid searching system's PATH as the SDK's general `Libraries` directory 
    # may be used instead of the platform's directory
    find_file(ARDUINO_CMAKE_PLATFORM_PROGRAMMERS_PATH
            NAMES programmers.txt
            PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
            DOC "Path to Platform's programmers definition file"
            NO_SYSTEM_ENVIRONMENT_PATH
            NO_CMAKE_FIND_ROOT_PATH)

endfunction()

function(find_platform_boards)

    # Avoid searching system's PATH as the SDK's general `Libraries` directory 
    # may be used instead of the platform's directory
    find_file(ARDUINO_CMAKE_PLATFORM_BOARDS_PATH
            NAMES boards.txt
            PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
            DOC "Path to Platform's boards definition file"
            NO_SYSTEM_ENVIRONMENT_PATH
            NO_CMAKE_FIND_ROOT_PATH)

endfunction()

function(find_platform_properties_file)

    # Avoid searching system's PATH as the SDK's general `Libraries` directory 
    # may be used instead of the platform's directory
    find_file(ARDUINO_CMAKE_PLATFORM_PROPERTIES_FILE_PATH
            NAMES platform.txt
            PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
            DOC "Path to Platform's properties file"
            NO_SYSTEM_ENVIRONMENT_PATH
            NO_CMAKE_FIND_ROOT_PATH)

endfunction()

function(find_platform_libraries)

    # Avoid searching system's PATH as the SDK's general `Libraries` directory 
    # may be used instead of the platform's directory
    find_file(ARDUINO_CMAKE_PLATFORM_LIBRARIES_PATH
            NAMES libraries
            PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
            DOC "Path to platform directory containing the Arduino libraries"
            NO_SYSTEM_ENVIRONMENT_PATH
            NO_CMAKE_FIND_ROOT_PATH)

    file(GLOB sub-dir "${ARDUINO_CMAKE_PLATFORM_LIBRARIES_PATH}/*")
    set(platform_lib_list)
    foreach (dir ${sub-dir})
        if (IS_DIRECTORY ${dir})
            get_filename_component(platform_lib ${dir} NAME)
            string(TOLOWER ${platform_lib} platform_lib)
            set(ARDUINO_CMAKE_LIBRARY_${platform_lib}_PATH ${dir} CACHE INTERNAL
                    "Path to ${platform_lib} platform library")
            list(APPEND platform_lib_list ${platform_lib})
        endif ()
    endforeach ()

    set(ARDUINO_CMAKE_PLATFORM_LIBRARIES "${platform_lib_list}" CACHE STRING
            "List of existing platform libraries")

endfunction()

#=============================================================================#
# Finds platform's main header file by iterating over all headers under all core directories,
# looking for the one with the most '#include' lines as it can be presumed as the main header.
# The header is stored in cache in 2 variants:
#       1. ARDUINO_CMAKE_PLATFORM_HEADER_NAME - Header's name with its' file extension
#       2. ARDUINO_CMAKE_PLATFORM_HEADER_PATH - Full path to the header file
#=============================================================================#
function(find_platform_main_header)

    set(max_includes 0) # Track the biggest number of include lines to perform quick swap

    foreach (core ${ARDUINO_CMAKE_PLATFORM_CORES})
        find_header_files("${ARDUINO_CMAKE_CORE_${core}_PATH}" core_headers)
        foreach (header ${core_headers})
            file(STRINGS "${header}" header_content)
            list(FILTER header_content INCLUDE REGEX "^#include")
            # Count the number of includes
            list(LENGTH header_content num_of_includes)
            # Check if current number is bigger than the known maximum, swap if it is
            if (${num_of_includes} GREATER ${max_includes})
                set(biggest_header ${header})
                set(max_includes ${num_of_includes})
            endif ()
        endforeach ()
    endforeach ()

    # Platform's header is probably the one with the biggest number of include lines
    message(STATUS "Determined Platform Header: ${biggest_header}")
    # Store both header's name (with extension) and path
    get_filename_component(platform_header_name "${biggest_header}" NAME)
    set(ARDUINO_CMAKE_PLATFORM_HEADER_NAME "${platform_header_name}" CACHE STRING
            "Platform's main header name (With extension)")
    set(ARDUINO_CMAKE_PLATFORM_HEADER_PATH "${biggest_header}" CACHE PATH
            "Path to platform's main header file")

endfunction()
