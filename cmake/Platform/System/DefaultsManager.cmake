#=============================================================================#
# Sets various defaults related directly to the Arduino-CMake platform.
#=============================================================================#
function(set_arduino_cmake_defaults)

    option(USE_DEFAULT_PLATFORM_IF_NONE_EXISTING
            "Whether to use Arduino as default platform if none is supplied" ON)
    option(USE_ARCHLINUX_BUILTIN_SUPPORT
            "Whether to use Arduino CMake's built-in support for the archlinux distribution" ON)
    set(ARDUINO_CMAKE_SEMICOLON_REPLACEMENT "!@&#%" CACHE STRING
            "String replacement for the semicolon char, required when treating lists as code")

endfunction()
