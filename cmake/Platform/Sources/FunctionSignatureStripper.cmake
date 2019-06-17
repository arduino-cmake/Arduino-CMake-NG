#=============================================================================#
# Gets the types of a function's arguments as a list.
#       _signature - String representing a full function signature, e.g. 'int main(int argc, char **argv)'
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - List of types, matching the given function-argument string.
#=============================================================================#
function(_get_function_arguments_types _signature _return_var)

    get_property(function_args_regex GLOBAL PROPERTY ARDUINO_CMAKE_FUNCTION_ARGS_REGEX_PATTERN)
    get_property(function_single_arg_regex GLOBAL PROPERTY ARDUINO_CMAKE_FUNCTION_SINGLE_ARG_REGEX_PATTERN)
    get_property(function_arg_type_regex GLOBAL PROPERTY ARDUINO_CMAKE_FUNCTION_ARG_TYPE_REGEX_PATTERN)

    string(REGEX MATCH ${function_args_regex} function_args_string "${_signature}")
    string(REGEX MATCHALL ${function_single_arg_regex}
            function_arg_list "${function_args_string}")
    # Iterate through all arguments to extract only their type
    foreach (arg ${function_arg_list})

        string(REGEX MATCH ${function_arg_type_regex} arg_type "${arg}")
        string(STRIP "${arg_type}" arg_type) # Strip remaining whitespaces

        if (NOT "${arg_type}" STREQUAL "void") # Do NOT append 'void' arguments - they're meaningless
            list(APPEND function_args ${arg_type})
        endif ()

    endforeach ()

    set(${_return_var} ${function_args} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Strips a given function signature to its name and its arguments' types.
#       _signature - String representing a full function signature, e.g. 'int main(int argc, char **argv)'
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - List consisting of the function's name and arguments types.
#=============================================================================#
function(strip_function_signature _signature _return_var)

    get_property(function_name_regex GLOBAL PROPERTY ARDUINO_CMAKE_FUNCTION_NAME_REGEX_PATTERN)

    # Strip function's name
    string(REGEX MATCH ${function_name_regex} function_name_match "${_signature}")
    set(function_name ${CMAKE_MATCH_1})
    list(APPEND stripped_signature ${function_name})

    # Strip arguments types , i.e. without names
    _get_function_arguments_types("${_signature}" function_args_types)
    list(APPEND stripped_signature ${function_args_types})

    set(${_return_var} ${stripped_signature} PARENT_SCOPE)

endfunction()