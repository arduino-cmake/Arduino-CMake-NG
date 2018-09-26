#=============================================================================#
# Parses the given arguments for sources, stopping when all arguments have been read or
# when at least one reserved argument/option has been encountered.
#       _reserved_options - Reserved option arguments.
#       _reserved_single_values - Reserved single-value arguments.
#       _reserved_multi_values - Reserved multi-value arguments.
#       _cmake_args - Arguments to parse. Usually function's unparsed arguments - ${ARGN}.
#       _return_var - Name of a CMake variable that will hold the extraction result.
#       Returns - Parsed sources.
#=============================================================================#
function(parse_sources_arguments _return_var _reserved_options _reserved_single_values
        _reserved_multi_values _cmake_args)

    # Prepare arguments for further inspection - Somewhat croocked logic due to CMake's limitations
    # If an argument is an empty string, populate it with a theoritcally impossible value.
    # just to have some value in it
    if ("${_reserved_options}" STREQUAL "")
        set(_reserved_options "+-*/")
    endif ()
    if ("${_reserved_single_values}" STREQUAL "")
        set(_reserved_single_values "+-*/")
    endif ()
    if ("${_reserved_multi_values}" STREQUAL "")
        set(_reserved_multi_values "+-*/")
    endif ()

    set(sources "") # Clear list because cmake preserves scope in nested functions

    foreach (arg ${_cmake_args})

        if (${arg} IN_LIST _reserved_options OR
                ${arg} IN_LIST _reserved_single_values OR
                ${arg} IN_LIST _reserved_multi_values)
            break()
        else ()
            list(APPEND sources ${arg})
        endif ()

    endforeach ()

    set(${_return_var} ${sources} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Parses the given arguments for scope-controlling arguments, which are PUBLIC|INTERFACE|PRIVATE.
# If none is found, CMake generates an error, unless - The DEFAULT_SCOPE argument is passed.
#       _cmake_args - Arguments to parse. Usually function's unparsed arguments - ${ARGN}.
#       [DEFAULT_SCOPE] - Optional default scope to return in case none is found in arguments.
#       _return_var - Name of a CMake variable that will hold the extraction result.
#       Returns - Parsed scope if one is found or the DEFAULT_SCOPE if set, otherwise an error.
#=============================================================================#
function(parse_scope_argument _return_var _cmake_args)

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
