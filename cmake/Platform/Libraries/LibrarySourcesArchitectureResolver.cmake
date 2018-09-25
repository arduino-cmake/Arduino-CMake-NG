function(_filter_unsupported_arch_sources _unsupported_archs_regex _sources _return_var)

    #string(LENGTH _unsupported_archs_regex num_of_unsupported_archs)

    if (NOT "${_unsupported_archs_regex}" STREQUAL "") # Not all architectures are supported
        # Filter sources dependant on unsupported architectures
        list(FILTER _sources EXCLUDE REGEX ${_unsupported_archs_regex})
    endif ()

    set(${_return_var} ${_sources} PARENT_SCOPE)

endfunction()

function(resolve_library_sources_by_architecture _library_root_dir _library_sources _return_var)

    cmake_parse_arguments(parsed_args "" "LIB_PROPS_FILE" "" ${ARGN})

    if (parsed_args_LIB_PROPS_FILE) # Library properties file is given
        set(lib_props_file ${parsed_args_LIB_PROPS_FILE})
    else () # Try to automatically find file from sources

        # Get the absolute root directory (full path)
        get_filename_component(absolute_lib_root_dir ${_library_root_dir} ABSOLUTE)

        if (EXISTS ${absolute_lib_root_dir}/library.properties)
            set(lib_props_file ${absolute_lib_root_dir}/library.properties)

        else () # Properties file can't be found - Warn user and assume library is arch-agnostic

            get_filename_component(library_name ${absolute_lib_root_dir} NAME)
            message(WARNING "\"${library_name}\" library's properties file can't be found "
                    "under its' root directory - Assuming the library "
                    "is architecture-agnostic (supports all architectures)")
            set(${_return_var} ${_library_sources} PARENT_SCOPE)
            return()

        endif ()

    endif ()

    get_arduino_library_supported_architectures("${lib_props_file}" lib_archs)
    is_library_supports_platform_architecture(${lib_archs} arch_supported_by_lib)

    if (NOT ${arch_supported_by_lib})
        string(CONCAT error_message
                "The ${_library_name} "
                "library isn't supported on the platform's architecture "
                "${ARDUINO_CMAKE_PLATFORM_ARCHITECTURE}")
        message(SEND_ERROR ${error_message})
    endif ()

    get_unsupported_architectures("${lib_archs}" unsupported_archs REGEX)

    # Filter any sources that aren't supported by the platform's architecture
    _filter_unsupported_arch_sources("${unsupported_archs}" "${_library_sources}" valid_sources)

    set(${_return_var} "${valid_sources}" PARENT_SCOPE)

endfunction()
