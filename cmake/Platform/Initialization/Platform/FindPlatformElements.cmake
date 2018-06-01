function(_find_platform_cores)

    set(core_list "")

    file(GLOB sub-dir ${PLATFORM_CORES_PATH}/*)
    foreach (dir ${sub-dir})
        if (IS_DIRECTORY ${dir})
            get_filename_component(core ${dir} NAME)
            string(TOUPPER ${core} CORE)
            set(ARDUINO_CMAKE_CORE_${CORE}_PATH "${dir}" CACHE INTERNAL "Path to ${core} core")
            list(APPEND core_list ${CORE})
        endif ()
    endforeach ()

    list(GET core_list 0 main_core)
    set(ARDUINO_CMAKE_PLATFORM_DEFAULT_CORE "${main_core}" CACHE STRING "Default platform core")
    set(ARDUINO_CMAKE_PLATFORM_CORES "${core_list}" CACHE STRING "List of existing platform cores")

endfunction()

function(_find_platform_variants)

    file(GLOB sub-dir ${PLATFORM_VARIANTS_PATH}/*)
    foreach (dir ${sub-dir})
        if (IS_DIRECTORY ${dir})
            get_filename_component(variant ${dir} NAME)
            string(TOUPPER ${variant} VARIANT)
            set(ARDUINO_CMAKE_VARIANT_${VARIANT}_PATH ${dir} CACHE INTERNAL "Path to ${variant} variant")
        endif ()
    endforeach ()

endfunction()

find_file(ARDUINO_CMAKE_PLATFORM_CORES_PATH
        NAMES cores
        PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
        DOC "Path to directory containing the Platform's core sources"
        NO_CMAKE_FIND_ROOT_PATH)
_find_platform_cores()

find_file(ARDUINO_CMAKE_PLATFORM_VARIANTS_PATH
        NAMES variants
        PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
        DOC "Path to directory containing the Platform's variant sources"
        NO_CMAKE_FIND_ROOT_PATH)
_find_platform_variants()

find_file(ARDUINO_CMAKE_PLATFORM_BOOTLOADERS_PATH
        NAMES bootloaders
        PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
        DOC "Path to directory containing the Platform's bootloader images and sources"
        NO_CMAKE_FIND_ROOT_PATH)

find_file(ARDUINO_CMAKE_PLATFORM_PROGRAMMERS_PATH
        NAMES programmers.txt
        PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
        DOC "Path to Platform's programmers definition file"
        NO_CMAKE_FIND_ROOT_PATH)

find_file(ARDUINO_CMAKE_PLATFORM_BOARDS_PATH
        NAMES boards.txt
        PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
        DOC "Path to Platform's boards definition file"
        NO_CMAKE_FIND_ROOT_PATH)

find_file(ARDUINO_CMAKE_PLATFORM_PROPERTIES_FILE_PATH
        NAMES platform.txt
        PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
        DOC "Path to Platform's properties file"
        NO_CMAKE_FIND_ROOT_PATH)

find_file(ARDUINO_CMAKE_PLATFORM_LIBRARIES_PATH
        NAMES libraries
        PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
        DOC "Path to platform directory containing the Arduino libraries"
        NO_CMAKE_FIND_ROOT_PATH)
