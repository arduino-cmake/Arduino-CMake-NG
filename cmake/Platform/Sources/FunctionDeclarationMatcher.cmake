#=============================================================================#
# Attempts to match a given function definition signature to its' declaration, searching in all given headers.
# These headers are usually a list of all headers included by the function's file, recursively.
# Given a match, the declaration is returned, otherwise - "NOTFOUND" string.
#       _definition_signature - String representing a full function signature, e.g. 'int main(int argc, char **argv)'
#       _included_headers - List of headers to search the declaration in.
#                           Should include the function's containing file itself.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Function's declaration signature if exists, otherwise "NOTFOUND".
#=============================================================================#
function(match_function_declaration _definition_signature _included_headers _return_var)

    # Get function name and list of argument-types
    strip_function_signature("${_definition_signature}" original_stripped_function)
    list(GET original_stripped_function 0 original_function_name)
    list_max_index("${original_stripped_function}" original_function_args_length)

    foreach (included_header ${_included_headers})

        file(STRINGS "${included_header}" header_lines)

        foreach (line ${header_lines})

            # Search for function declarations
            if ("${line}" MATCHES "${ARDUINO_CMAKE_FUNCTION_DECLARATION_REGEX_PATTERN}")

                # Get function name and list of argument-types
                strip_function_signature("${line}" iterated_stripped_function)
                list(GET iterated_stripped_function 0 iterated_function_name)
                list_max_index("${iterated_stripped_function}" iterated_function_args_length)

                if ("${original_function_name}" STREQUAL "${iterated_function_name}")
                    if (${orig_func_list_len} EQUAL ${iter_func_list_len})

                        set(arg_types_match TRUE)

                        if (${iterated_function_args_length} GREATER 0)
                            foreach (arg_type_index RANGE 1 ${iterated_function_args_length})

                                list(GET original_stripped_function ${arg_type_index} orig_arg_type)
                                list(GET iterated_stripped_function ${arg_type_index} iter_arg_type)

                                if (NOT ${orig_arg_type} EQUAL ${iter_arg_type})
                                    set(arg_types_match FALSE)
                                    break()
                                endif ()

                            endforeach ()
                        endif ()

                        if (${arg_types_match}) # Signature has been matched
                            set(${_return_var} ${line} PARENT_SCOPE)
                            return()
                        endif ()

                    endif ()
                endif ()

            endif ()

        endforeach ()

    endforeach ()

    set(${_return_var} "NOTFOUND" PARENT_SCOPE)

endfunction()
