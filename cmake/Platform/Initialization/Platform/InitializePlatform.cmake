function(read_properties_files)

    # Read properties from property files based on type
    list(FIND PROPERTY_FILE_TYPES platform file_type)
    read_properties(${PLATFORM_PROPERTIES_FILE_PATH} ${file_type})

    list(FIND PROPERTY_FILE_TYPES boards file_type)
    read_properties(${PLATFORM_BOARDS_PATH} ${file_type})

    list(FIND PROPERTY_FILE_TYPES programmers file_type)
    read_properties(${PLATFORM_PROGRAMMERS_PATH} ${file_type})

endfunction()

include(PropertiesReader)

if (NOT DEFINED ARDUINO_CMAKE_PLATFORM_NAME OR NOT DEFINED ARDUINO_CMAKE_PLATFORM_PATH)
    if (USE_DEFAULT_PLATFORM_IF_NONE_EXISTING)
        set(ARDUINO_CMAKE_PLATFORM_NAME "arduino" CACHE STRING "")
        set(ARDUINO_CMAKE_PLATFORM_ARCHITECTURE "avr" CACHE STRING "")
        set(ARDUINO_CMAKE_PLATFORM_PATH "${ARDUINO_SDK_PATH}/hardware/${ARDUINO_CMAKE_PLATFORM_NAME}/${ARDUINO_CMAKE_PLATFORM_ARCHITECTURE}" CACHE PATH "")
    else ()
        message(FATAL_ERROR "Arduino Platform must be defined through name and path")
    endif ()
elseif (NOT DEFINED ARDUINO_CMAKE_PLATFORM_ARCHITECTURE) # Platform defined without architecture
    set(ARDUINO_CMAKE_PLATFORM_ARCHITECTURE "avr" CACHE STRING "")
endif ()

include(FindPlatformElements)

# Setup property file types
set(PROPERTY_FILE_TYPES platform boards programmers CACHE STRING "Types of property files")

read_properties_files()
