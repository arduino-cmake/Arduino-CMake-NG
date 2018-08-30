#=============================================================================#
# Resolves the given value by trying to find a variable with the same name.
# The variable can be a Cache variable or a board property.
# The original, given value is then replaced with the resolved one.
#        _value - Value to resolve, enclosed in curly-brackets ('{}')
#        _return_var - Name of variable in parent-scope holding the return value.
#        Returns - Resolved value if one is found, nothing otherwise.
#=============================================================================#
function(_resolve_single_value _value _return_var)

    set(extra_args ${ARGN})

    string(REGEX REPLACE "^{(.+)}$" "\\1" value "${_value}") # Get only the value
    string(REPLACE "." "_" value_as_var "${value}")
    if (DEFINED ${value_as_var}) # Value is a variable (Probably cache)
        set(${_return_var} "${${value_as_var}}" PARENT_SCOPE)
    else ()
        # Get extra arguments
        list(LENGTH extra_args num_of_extra_args)
        if (${num_of_extra_args} EQUAL 0) # No extra arguments
            return() # Link simply not found, it's probably desired
        elseif (${num_of_extra_args} EQUAL 1)
            list(GET extra_args 0 board_id)
        endif ()

        # Maybe value is a board property?
        try_get_board_property("${board_id}" "${value}" value_as_board_property)
        if (NOT "${value_as_board_property}" STREQUAL "") # Value is indeed a board property
            set(${_return_var} ${value_as_board_property} PARENT_SCOPE)
        endif ()
    endif ()

endfunction()

#=============================================================================#
# Resolves the given value by trying to find a variable with the same name for each 'inner-value'.
#        _value - Value to resolve as a list of 'inner-values', enclosed in curly-brackets ('{}')
#        _return_var - Name of variable in parent-scope holding the return value.
#        Returns - Resolved list of values. If nothing is resolved, simply the original list.
#=============================================================================#
function(_resolve_list_value _value _return_var)

    set(index 0)
    set(temp_list "${_value}")

    foreach (value_entry ${_value})
        set(index_inc 1) # Always reset incrementation to 1
        if ("${value_entry}" MATCHES "^{.+}$") # Wrapped with brackets - resolvable
            _resolve_single_value(${value_entry} resolved_entry "${ARGN}")
            if (DEFINED resolved_entry) # Entry has been resolved
                if ("${resolved_entry}" STREQUAL "") # Resolved entry is an empty string
                    list(REMOVE_AT temp_list ${index}) # Remove the entry completely
                    decrement_integer(index 1)
                else ()
                    # Replace old value with new resolved value
                    list_replace(temp_list ${index} "${resolved_entry}")
                    # Also enlrage the index incrementation if resolved entry is a list
                    list(LENGTH resolved_entry num_of_inner_resolved_entries)
                    if (${num_of_inner_resolved_entries} GREATER 1)
                        set(index_inc ${num_of_inner_resolved_entries})
                    endif ()
                endif ()
            endif ()
        endif ()
        increment_integer(index ${index_inc})
    endforeach ()

    set(${_return_var} "${temp_list}" PARENT_SCOPE)

endfunction()

#=============================================================================#
# Resolves the given value by trying to find a variable with the same name.
# The value can be a single value or a list value, and is resolved accordingly.
#        _value - Value to resolve.
#        _return_var - Name of variable in parent-scope holding the return value.
#        Returns - Resolved value if one is found, original value otherwise.
#=============================================================================#
function(_resolve_value _value _return_var)

    # Don't resolve empty values - There's nothing to resolve
    if ("${_value}" STREQUAL "")
        set(${_return_var} "" PARENT_SCOPE)
        return()
    endif ()

    # Treat value as if it were a list and get its length to know if it's actually a list or not
    list(LENGTH _value value_list_length)
    if (${value_list_length} GREATER 1)
        _resolve_list_value("${_value}" resolved_var "${ARGN}")
    else ()
        if (NOT "${_value}" MATCHES "^{.+}$") # No wrapping brackets, shouldn't be resolved
            set(resolved_var "${_value}")
        else ()
            _resolve_single_value("${_value}" resolved_var "${ARGN}")
        endif ()
    endif ()

    set(${_return_var} "${resolved_var}" PARENT_SCOPE)

endfunction()
