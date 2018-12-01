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

    cmake_parse_arguments(parsed_args "INTERFACE" "" "" ${ARGN})

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

    set_target_architecture_definition(${_target_name} ${scope} ${ARDUINO_CMAKE_PLATFORM_ARCHITECTURE})

endfunction()

#=============================================================================#
# Links the given library target to the given target, be it an executable or another library.
# The function first adds the includes of the Core Lib to the given library,
# then links it to the library.
#       _target_name - Name of the target to link against.
#       _library_name - Name of the library target to link.
#       [PRIVATE|PUBLIC|INTERFACE] - Optional link scope for the internally linked Core-Lib.
#       [BOARD_CORE_TARGET] - Optional target name of the Core Lib to use.
#                             Use when the target is a library.
#=============================================================================#
function(_link_arduino_cmake_library _target_name _library_name)

    if (NOT TARGET ${_target_name})
        message(FATAL_ERROR "Target doesn't exist - It must be created first!")
    endif ()

    cmake_parse_arguments(parsed_args "" "BOARD_CORE_TARGET" "" ${ARGN})
    parse_scope_argument(scope "${ARGN}")

    # Resolve Core-Lib's target
    if (parsed_args_BOARD_CORE_TARGET)
        set(core_target ${parsed_args_BOARD_CORE_TARGET})
    else ()
        set(core_target ${${_target_name}_CORE_LIB_TARGET})
    endif ()

    get_target_property(core_lib_includes ${core_target} INCLUDE_DIRECTORIES)

    # Include core lib's include directories in library target, then link to it
    target_include_directories(${_library_name} ${scope} "${core_lib_includes}")
    target_link_libraries(${_library_name} ${scope} ${core_target})

    # Link library target to linked-to target
    if (parsed_args_PRIVATE)
        target_link_libraries(${_target_name} PRIVATE ${_library_name})
    else ()
        # Link 'INTERFACE' targets publicly, otherwise code won't compile
        target_link_libraries(${_target_name} PUBLIC ${_library_name})
    endif ()

endfunction()
