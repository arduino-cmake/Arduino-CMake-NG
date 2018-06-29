include(AvrToolsFinder)
include(VersionDetector)
include(PlatformInitializer)

function(find_required_platform_tools)

    find_tool_avr_objcopy()
    find_tool_avrdude()
    find_tool_avrdude_configuration()
    find_tool_avrsize()

endfunction()

#=============================================================================#
# Initializes build system by setting defaults, finding tools and initializing the hardware-platform.
#=============================================================================#
function(initialize_build_system)

    set_source_files_pattern()
    set_arduino_cmake_defaults()
    find_required_platform_tools()
    detect_sdk_version()

    initialize_arduino_platform()

endfunction()
