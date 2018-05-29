find_file(PLATFORM_CORES_PATH
        NAMES cores
        PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
        DOC "Path to directory containing the Platform's core sources"
        NO_CMAKE_FIND_ROOT_PATH)

find_file(PLATFORM_VARIANTS_PATH
        NAMES variants
        PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
        DOC "Path to directory containing the Platform's variant sources"
        NO_CMAKE_FIND_ROOT_PATH)

find_file(PLATFORM_BOOTLOADERS_PATH
        NAMES bootloaders
        PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
        DOC "Path to directory containing the Platform's bootloader images and sources"
        NO_CMAKE_FIND_ROOT_PATH)

find_file(PLATFORM_PROGRAMMERS_PATH
        NAMES programmers.txt
        PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
        DOC "Path to Platform's programmers definition file"
        NO_CMAKE_FIND_ROOT_PATH)

find_file(PLATFORM_BOARDS_PATH
        NAMES boards.txt
        PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
        DOC "Path to Platform's boards definition file"
        NO_CMAKE_FIND_ROOT_PATH)

find_file(PLATFORM_PROPERTIES_FILE_PATH
        NAMES platform.txt
        PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
        DOC "Path to Platform's properties file"
        NO_CMAKE_FIND_ROOT_PATH)

find_file(PLATFORM_LIBRARIES_PATH
        NAMES libraries
        PATHS ${ARDUINO_CMAKE_PLATFORM_PATH}
        DOC "Path to platform directory containing the Arduino libraries"
        NO_CMAKE_FIND_ROOT_PATH)

#[[if (${PLATFORM}_BOARDS_PATH)
    set(SETTINGS_LIST ${PLATFORM}_BOARDS)
    set(SETTINGS_PATH "${${PLATFORM}_BOARDS_PATH}")
    include(LoadArduinoPlatformSettings)
endif ()

if (${PLATFORM}_PROGRAMMERS_PATH)
    set(SETTINGS_LIST ${PLATFORM}_PROGRAMMERS)
    set(SETTINGS_PATH "${${PLATFORM}_PROGRAMMERS_PATH}")
    include(LoadArduinoPlatformSettings)
endif ()]]
