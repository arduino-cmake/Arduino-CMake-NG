#=============================================================================#
# Gets the types of a function's arguments as a list.
#       _signature - String representing a full function signature, e.g. 'int main(int argc, char **argv)'
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - List of types, matching the given function-argument string.
#=============================================================================#
function(_get_function_arguments_types _signature _return_var)

    string(REGEX MATCH ${ARDUINO_CMAKE_FUNCTION_ARGS_REGEX_PATTERN} function_args_string "${_signature}")
    string(REGEX MATCHALL ${ARDUINO_CMAKE_FUNCTION_SINGLE_ARG_REGEX_PATTERN}
            function_arg_list "${_function_args_string}")

    # Iterate through all arguments to extract only their type
    foreach (arg ${function_arg_list})
        string(REGEX MATCH ${ARDUINO_CMAKE_FUNCTION_ARG_TYPE_REGEX_PATTERN} arg_type "${arg}")
        string(STRIP "${arg_type}" arg_type) # Strip remaining whitespaces
        list(APPEND function_args ${arg_type})
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

    # Strip function's name
    string(REGEX MATCH ${ARDUINO_CMAKE_FUNCTION_NAME_REGEX_PATTERN} function_name_match "${_signature}")
    set(function_name ${CMAKE_MATCH_1})
    list(APPEND stripped_signature ${function_name})

    # Strip arguments types , i.e. without names
    _get_function_arguments_types("${_signature}" function_args_types)
    list(APPEND stripped_signature ${function_args_types})

    set(${_return_var} ${stripped_signature} PARENT_SCOPE)

endfunction()