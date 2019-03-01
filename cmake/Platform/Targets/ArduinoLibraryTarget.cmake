#=============================================================================#
# Creates a library target for the given name and sources.
# As it's an Arduino library, it also finds and links all dependent platform libraries (if any).
#       _target_name - Name of the library target to be created. Usually library's real name.
#       [PLATFORM] -
#       [Sources] - List of source files (Could also be headers for code-inspection in some IDEs)
#                   to create the executable from, similar to CMake's built-in add_executable.
#=============================================================================#
function(add_arduino_library _target_name)

    # First parse keyword arguments
    cmake_parse_arguments(parsed_args "PLATFORM" "" "" ${ARGN})
    # Then parse unlimited sources
    parse_sources_arguments(parsed_sources "PLATFORM" "" "" "${ARGN}")

    if (parsed_sources)

        get_sources_root_directory("${parsed_sources}" library_root_dir)

        get_library_properties_file(${library_root_dir} library_properties_file)
        if (library_properties_file) # Properties file has been found
            resolve_library_architecture("${parsed_sources}" arch_resolved_sources
                    LIB_PROPS_FILE ${library_properties_file})
        else ()
            resolve_library_architecture("${parsed_sources}" arch_resolved_sources)
        endif ()

        _add_arduino_cmake_library(${_target_name} "${arch_resolved_sources}")

    else () # No sources have been provided at this stage, simply create a library target
        _add_arduino_cmake_library(${_target_name} "")
    endif ()

    if (parsed_args_PLATFORM)
        return()
    endif ()

    find_dependent_platform_libraries("${arch_resolved_sources}" lib_platform_libs)

    foreach (platform_lib ${lib_platform_libs})
        link_platform_library(${_target_name} ${platform_lib})
    endforeach ()

endfunction()

#=============================================================================#
# Creates a header-only library target for the given name and sources.
#       _target_name - Name of the "executable" target.
#=============================================================================#
function(add_arduino_header_only_library _target_name)

    parse_sources_arguments(parsed_headers "" "" "" "${ARGN}")

    _add_arduino_cmake_library(${_target_name} "${parsed_headers}" INTERFACE)

endfunction()

#=============================================================================#
# Links the given library target to the given "executable" target, but first,
# it adds core lib's include directories to the libraries include directories.
#       _target_name - Name of the "executable" target.
#       _library_target_name - Name of the library target.
#       [HEADER_ONLY] - Whether library is a header-only library, i.e has no source files
#=============================================================================#
function(link_arduino_library _target_name _library_target_name)

    cmake_parse_arguments(parsed_args "HEADER_ONLY" "" "" ${ARGN})

    if (NOT TARGET ${_target_name})
        message(FATAL_ERROR "Target doesn't exist - It must be created first!")
    elseif (NOT TARGET ${_library_target_name})
        message(FATAL_ERROR "Library target doesn't exist - It must be created first!")
    endif ()

    # Infer scope
    if (parsed_args_HEADER_ONLY)
        set(scope INTERFACE)
    else ()
        set(scope PUBLIC)
    endif ()

    _link_arduino_cmake_library(${_target_name} ${_library_target_name}
            ${scope}
            BOARD_CORE_TARGET ${${PROJECT_${ARDUINO_CMAKE_PROJECT_NAME}_BOARD}_CORELIB_TARGET})

endfunction()
