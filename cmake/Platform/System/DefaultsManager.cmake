function(set_internal_patterns)

    set(ARDUINO_CMAKE_SEMICOLON_REPLACEMENT "!@&#%" CACHE STRING
            "String replacement for the semicolon char, required when treating lists as code")
    set(ARDUINO_CMAKE_HEADER_INCLUDE_REGEX_PATTERN "^#include[<\"]" CACHE STRING
            "Regex pattern matching header inclusion in a source file")
    set(ARDUINO_CMAKE_FUNCTION_REGEX_PATTERN "^([a-z]|[A-Z])+.*\(([a-z]|[A-Z])*\)"
            "Regex pattern matching a function signature in a source file")
    set(ARDUINO_CMAKE_HEADER_NAME_REGEX_PATTERN
            "${ARDUINO_CMAKE_HEADER_INCLUDE_REGEX_PATTERN}(.+)[>\"]$"
            "Regex pattern matching a header's name when wrapped in inclusion line")

endfunction()

#=============================================================================#
# Sets various defaults related directly to the Arduino-CMake platform.
#=============================================================================#
function(set_arduino_cmake_defaults)

    option(USE_DEFAULT_PLATFORM_IF_NONE_EXISTING
            "Whether to use Arduino as default platform if none is supplied" ON)
    option(USE_CUSTOM_PLATFORM_HEADER
            "Whether to expect and use a custom-supplied platform header, \
            skipping the selection algorithm" OFF)
    option(USE_ARCHLINUX_BUILTIN_SUPPORT
            "Whether to use Arduino CMake's built-in support for the archlinux distribution" ON)

endfunction()
