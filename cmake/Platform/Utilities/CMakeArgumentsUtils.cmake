#=============================================================================#
# Parses the given arguments for scope-controlling arguments, which are PUBLIC|INTERFACE|PRIVATE.
# If none is found, CMake generates an error, unless - The DEFAULT_SCOPE argument is passed.
#       _cmake_args - Arguments to parse. Usually function's unparsed arguments - ${ARGN}.
#       [DEFAULT_SCOPE] - Optional default scope to return in case none is found in arguments.
#       _return_var - Name of a CMake variable that will hold the extraction result.
#       Returns - Parsed scope if one is found or the DEFAULT_SCOPE if set, otherwise an error.
#=============================================================================#
function(parse_scope_argument _cmake_args _return_var)

    cmake_parse_arguments(parsed_args "" "DEFAULT_SCOPE" "" ${ARGN})

    set(scope_options "PRIVATE" "PUBLIC" "INTERFACE")
    cmake_parse_arguments(scope_args "${scope_options}" "" "" ${_cmake_args})

    # Now, link library to executable
    if (scope_args_PRIVATE)
        set(scope PRIVATE)
    elseif (scope_args_INTERFACE)
        set(scope INTERFACE)
    elseif (scope_args_PUBLIC)
        set(scope PUBLIC)
    else ()

        if (parsed_args_DEFAULT_SCOPE) # Use default scope if none are given
            set(scope ${parsed_args_DEFAULT_SCOPE})
        else ()
            message(SEND_ERROR "Can't parse scope arguments - None are given, or invalid!")
        endif ()

    endif ()

    set(${_return_var} ${scope} PARENT_SCOPE)

endfunction()
