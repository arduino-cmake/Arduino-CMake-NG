#=============================================================================#
# Consumes given arguments for reserved options and single-value options,
# returning a new argument-list without them, no matter where they are positioned.
# It allows easy parsing of arguments which are considered "unlimited",
# limited only by multi-value options.
#       _args - Arguments to consume. Usually function's unparsed arguments - ${ARGN}.
#       _reserved_options - Reserved option arguments.
#       _reserved_single_values - Reserved single-value arguments.
#       _return_var - Name of a CMake variable that will hold the extraction result.
#       Returns - Original argument-list without reserved options and single-value options.
#=============================================================================#
function(_consume_reserved_arguments _args _reserved_options _reserved_single_values _return_var)

    if("${_args}" STREQUAL "") # Check if there are any arguments at all
        return()
    endif()
    
    set(temp_arg_list ${_args})

    list(LENGTH _args args_length)
    
    decrement_integer(args_length 1) # We'll peform index iteration - It's always length-1

    foreach (index RANGE ${args_length})

        list(GET _args ${index} arg)

        if (${arg} IN_LIST _reserved_options)
            list(REMOVE_ITEM temp_arg_list ${arg})

        elseif (${arg} IN_LIST _reserved_single_values)

            # Get the next index to remove as well - It's the option's/key's value
            set(next_index ${index})
            increment_integer(next_index 1)

            list(REMOVE_AT temp_arg_list ${index} ${next_index})

        endif ()

    endforeach ()

    set(${_return_var} ${temp_arg_list} PARENT_SCOPE)

endfunction()

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

    # Initialize argument-lists for further inspection
    initialize_list(_reserved_options)
    initialize_list(_reserved_single_values)
    initialize_list(_reserved_multi_values)

    _consume_reserved_arguments("${_cmake_args}"
            "${_reserved_options}" "${_reserved_single_values}"
            consumed_args)

    set(sources "") # Clear list because cmake preserves scope in nested functions

    foreach (arg ${consumed_args})

        if (${arg} IN_LIST _reserved_multi_values)
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
