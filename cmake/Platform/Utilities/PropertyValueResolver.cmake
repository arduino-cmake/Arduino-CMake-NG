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
        elseif (${num_of_extra_args} GREATER 0)
            list(GET extra_args 1 board_id)
        endif ()

        # Maybe value is a board property?
        get_board_property(${board_id} "${value}" value_as_board_property)
        if (NOT "${value_as_board_property}" STREQUAL "") # Value is indeed a board property
            set(${_return_var} ${value_as_board_property} PARENT_SCOPE)
        endif ()
    endif ()

endfunction()

function(_resolve_list_value _value _return_var)

    set(index 0)
    foreach (value_entry ${_value})
        string(REGEX MATCH "^{.+}$" wrapping_brackets "${value_entry}")
        if ("${wrapping_brackets}" STREQUAL "") # No wrapping brackets, shouldn't be resolved
            set(${_return_var} ${value_entry} PARENT_SCOPE)
        else ()
            _resolve_single_value(${value_entry} resolved_entry)
            if (resolved_entry) # Entry has been resolved
                list_replace("${_value}" ${index} ${resolved_entry} _value)
            endif ()
        endif ()
        increment_integer(index 1)
    endforeach ()

    set(${_return_var} "${_value}" PARENT_SCOPE)

endfunction()

function(_resolve_value _value _return_var)

    # Treat value as if it were a list and get its length to know if it's actually a list or not
    list(LENGTH _value value_list_length)
    if (${value_list_length} GREATER 1)
        _resolve_list_value(" ${_value}" resolved_var)
    else ()
        string(REGEX MATCH "^{.+}$" wrapping_brackets "${_value}")
        if ("${wrapping_brackets}" STREQUAL "") # No wrapping brackets, shouldn't be resolved
            set(resolved_var "${_value}")
        else ()
            _resolve_single_value("${_value} " resolved_var)
        endif ()
    endif ()

    set(${_return_var} "${resolved_var}" PARENT_SCOPE)

endfunction()
