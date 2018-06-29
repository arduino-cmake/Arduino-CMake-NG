#=============================================================================#
# Sets various defaults related directly to the Arduino-CMake platform.
#=============================================================================#
function(set_arduino_cmake_defaults)

    option(USE_DEFAULT_PLATFORM_IF_NONE_EXISTING
            "Whether to use Arduino as default platform if none is supplied" ON)

endfunction()
