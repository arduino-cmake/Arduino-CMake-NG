#=============================================================================#
# Looks for any platform libraries (Resolved earlier when platform has been initialized)
# within the given sources and returns them in a list.
#       _sources - Source and header files to search dependent platform libraries in.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - List of found dependent platform libraries.
#=============================================================================#
function(find_dependent_platform_libraries _sources _return_var)

    foreach (source ${_sources})
        get_source_file_included_headers(${source} source_includes WE)
        list(APPEND included_headers_names ${source_includes})
    endforeach ()

    if (included_headers_names)
        list(REMOVE_DUPLICATES included_headers_names)
    endif ()

    get_platform_libraries_from_names("${included_headers_names}" dependent_libs)

    set(${_return_var} ${dependent_libs} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Creates a platform library target with the given name.
#       _library_name - Name of the library target to create, usually the platform library name.
#       _board_id - Board ID associated with the linked Core Lib.
#=============================================================================#
function(_add_platform_library _library_name _board_id)

    find_library_header_files("${ARDUINO_CMAKE_PLATFORM_LIBRARIES_PATH}/${_library_name}/src"
            lib_headers)
    find_library_source_files("${ARDUINO_CMAKE_PLATFORM_LIBRARIES_PATH}/${_library_name}/src"
            lib_source_files)

    set(lib_sources ${lib_headers} ${lib_source_files})

    _add_arduino_cmake_library(${_library_name} ${_board_id} "${lib_sources}")

endfunction()

#=============================================================================#
# Links the given platform library target to the given target.
#       _target_name - Name of the target to link against.
#       _library_name - Name of the library target to create, usually the platform library name.
#       _board_id - Board ID associated with the linked Core Lib.
#=============================================================================#
function(link_platform_library _target_name _library_name _board_id)

    if (NOT TARGET ${_target_name})
        message(FATAL_ERROR "Target ${_target_name} doesn't exist - It must be created first!")
    endif ()

    parse_scope_argument(scope "${ARGN}"
            DEFAULT_SCOPE PUBLIC)

    if (NOT TARGET ${_library_name})

        _add_platform_library(${_library_name} ${_board_id})

        get_core_lib_target_name(${_board_id} core_lib_target)
        _link_arduino_cmake_library(${_target_name} ${_library_name}
                ${scope}
                BOARD_CORE_TARGET ${core_lib_target})

    else ()
        target_link_libraries(${_target_name} ${scope} ${_library_name})
    endif ()

endfunction()
