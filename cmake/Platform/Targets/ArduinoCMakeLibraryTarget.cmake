#=============================================================================#
# Creates a library target compliant with the Arduino library standard.
# One can also specify an architecture for the library, which will result in a special parsing
# of the sources, ommiting non-compliant sources.
#       _target_name - Name of the library target to be created. Usually library's real name.
#       _board_id - Board ID associated with the linked Core Lib.
#       _sources - Source and header files to create library target from.
#       [ARCH] - Optional library architecture (Such as 'avr', 'nrf52', etc.).
#       [INTERFACE] - Whether the library should be created as an interface library (header-only).
#=============================================================================#
function(_add_arduino_cmake_library _target_name _board_id _sources)

    cmake_parse_arguments(parsed_args "INTERFACE" "ARCH" "" ${ARGN})

    if (parsed_args_ARCH) # Treat architecture-specific libraries differently
        # Filter any sources that aren't supported by the platform's architecture
        list(LENGTH library_ARCH num_of_libs_archs)
        if (${num_of_libs_archs} GREATER 1)
            # Exclude all unsupported architectures, request filter in regex mode
            get_unsupported_architectures("${parsed_args_ARCH}" arch_filter REGEX)
            set(filter_type EXCLUDE)
        else ()
            set(arch_filter "src\\/[^/]+\\.|${parsed_args_ARCH}")
            set(filter_type INCLUDE)
        endif ()
        list(FILTER _sources ${filter_type} REGEX ${arch_filter})
    endif ()

    if (parsed_args_INTERFACE)
        add_library(${_target_name} INTERFACE)
        set(scope INTERFACE)
    else ()
        add_library(${_target_name} STATIC "${_sources}")
        set(scope PUBLIC)
    endif ()

    # Treat headers' parent directories as include directories of the target
    get_headers_parent_directories("${_sources}" include_dirs)
    target_include_directories(${_target_name} ${scope} ${include_dirs})

    set_library_flags(${_target_name} ${_board_id} ${scope})

    if (parsed_args_ARCH)
        string(TOUPPER ${parsed_args_ARCH} upper_arch)
        set(arch_definition "ARDUINO_ARCH_${upper_arch}")
        target_compile_definitions(${_target_name} ${scope} ${arch_definition})
    endif ()

endfunction()

#=============================================================================#
# Links the given library target to the given target, be it an executable or another library.
# The function first adds the includes of the Core Lib to the given library,
# then links it to the library.
#       _target_name - Name of the target to link against.
#       _library_name - Name of the library target to link.
#       [PRIVATE|PUBLIC|INTERFACE] - Optional link scope.
#       [BOARD_CORE_TARGET] - Optional target name of the Core Lib to use.
#                             Use when the target is a library.
#=============================================================================#
function(_link_arduino_cmake_library _target_name _library_name)

    if (NOT TARGET ${_target_name})
        message(FATAL_ERROR "Target doesn't exist - It must be created first!")
    endif ()

    set(scope_options "PRIVATE" "PUBLIC" "INTERFACE")
    cmake_parse_arguments(link_library "${scope_options}" "BOARD_CORE_TARGET" "" ${ARGN})

    # Now, link library to executable
    if (link_library_PUBLIC)
        set(scope PUBLIC)
    elseif (link_library_INTERFACE)
        set(scope INTERFACE)
    else ()
        set(scope PRIVATE)
    endif ()

    # First, include core lib's directories in library as well
    if (link_library_BOARD_CORE_TARGET)
        set(core_target ${link_library_BOARD_CORE_TARGET})
    else ()
        set(core_target ${${_target_name}_CORE_LIB_TARGET})
    endif ()

    get_target_property(core_lib_includes ${core_target} INCLUDE_DIRECTORIES)
    target_include_directories(${_library_name} ${scope} "${core_lib_includes}")
    target_link_libraries(${_library_name} ${scope} ${core_target})

    target_link_libraries(${_target_name} PRIVATE ${_library_name})

endfunction()
