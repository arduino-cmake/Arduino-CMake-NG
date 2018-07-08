function(_add_arduino_cmake_library _target_name _board_id _sources)

    cmake_parse_arguments(library "" "ARCH" "" ${ARGN})

    if (library_ARCH) # Treat architecture-specific libraries differently
        # Filter any sources that aren't supported by the platform's architecture
        list(LENGTH library_ARCH num_of_libs_archs)
        if (${num_of_libs_archs} GREATER 1)
            # Exclude all unsupported architectures, request filter in regex mode
            _get_unsupported_architectures("${library_ARCH}" arch_filter REGEX)
            set(filter_type EXCLUDE)
        else ()
            set(arch_filter "src\\/[^/]+\\.|${library_ARCH}")
            set(filter_type INCLUDE)
        endif ()
        list(FILTER _sources ${filter_type} REGEX ${arch_filter})
    endif ()

    add_library(${_target_name} STATIC "${_sources}")

    get_include_directories("${_sources}" include_dirs)
    target_include_directories(${_target_name} PUBLIC ${include_dirs})

    _set_library_flags(${_target_name} ${_board_id})

endfunction()

function(_link_arduino_cmake_library _target_name _library_name)

    if (NOT TARGET ${_target_name})
        message(FATAL_ERROR "Target doesn't exist - It must be created first!")
    endif ()

    set(scope_options "PRIVATE" "PUBLIC" "INTERFACE")
    cmake_parse_arguments(link_library "${scope_options}" "BOARD_CORE_TARGET" "" ${ARGN})

    # First, include core lib's directories in library as well
    if (link_library_BOARD_CORE_TARGET)
        set(core_target ${link_library_BOARD_CORE_TARGET})
    else ()
        set(core_target ${${_target_name}_CORE_LIB_TARGET})
    endif ()

    get_target_property(core_lib_includes ${core_target} INCLUDE_DIRECTORIES)
    target_include_directories(${_library_name} PRIVATE "${core_lib_includes}")

    # Now, link library to executable
    if (link_library_PUBLIC)
        set(scope PUBLIC)
    elseif (link_library_INTERFACE)
        set(scope INTERFACE)
    else ()
        set(scope PRIVATE)
    endif ()
    target_link_libraries(${_target_name} ${scope} ${_library_name})

endfunction()
