include(AvrToolsFinder)
include(VersionDetector)
include(PlatformInitializer)
include(LinuxDistDetector)
include(SketchbookFinder)

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

    set_arduino_cmake_defaults()
    find_required_platform_tools()
    detect_sdk_version()
    if (CMAKE_HOST_UNIX AND NOT CMAKE_HOST_APPLE) # Detect host's Linux distribution
        detect_host_linux_distribution()
    endif ()
    if (AUTO_SET_SKETCHBOOK_PATH)
        find_sketchbook_path()
    endif ()

    initialize_arduino_platform()

endfunction()
