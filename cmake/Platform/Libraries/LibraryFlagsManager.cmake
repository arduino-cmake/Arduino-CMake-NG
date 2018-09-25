#=============================================================================#
# Sets compiler and linker flags on the given library target.
# Changes are kept even outside the scope of the function since they apply on a target.
#       _library_target - Name of the library target.
#       _board_id - Board ID associated with the library. Some flags require it.
#=============================================================================#
function(set_library_flags _library_target _board_id)

    set(scope_options "PRIVATE" "PUBLIC" "INTERFACE")
    cmake_parse_arguments(parsed_args "${scope_options}" "" "" ${ARGN})

    if (parsed_args_PRIVATE)
        set(scope PRIVATE)
    elseif (parsed_args_INTERFACE)
        set(scope INTERFACE)
    else ()
        set(scope PUBLIC)
    endif ()

    # Set C++ compiler flags
    get_cmake_compliant_language_name(cpp flags_language)
    set_compiler_target_flags(${_library_target} "${_board_id}" ${scope} LANGUAGE ${flags_language})

    # Set linker flags
    set_linker_flags(${_library_target} "${_board_id}")

endfunction()
