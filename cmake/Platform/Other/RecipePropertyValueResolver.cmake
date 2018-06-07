function(_get_recipe_property_name _property _return_var)

    string(REGEX MATCH "^[^{]+" property_name "${_property}")
    set(${_return_var} "${property_name}" PARENT_SCOPE)

endfunction()

function(_get_recipe_property_value _property _return_var)

    string(STRIP "${_property}" stripped_property)
    string(REGEX MATCH "{.+}$" property_value "${stripped_property}")
    set(${_return_var} "${property_value}" PARENT_SCOPE)

endfunction()

function(_resolve_recipe_property _property _return_var)

    set(extra_args ${ARGN})
    list(LENGTH extra_args num_of_extra_args)

    string(REGEX MATCH "=" normal_property "${_property}")
    if ("${normal_property}" STREQUAL "") # Recipe property, doesn't have '='
        if ("${_property}" MATCHES "^\".+\"$") # Property enclosed with qutoes
            string(REPLACE "\"" "" _property "${_property}") # Omit quotes for now
            set(quoted_property TRUE)
        endif ()
        _get_recipe_property_name("${_property}" property_name)
        _get_recipe_property_value("${_property}" property_value)

        # If property has no value and can't be resolved, it probably has been already resolved
        if ("${property_value}" STREQUAL "" AND "${property_name}" STREQUAL "${_property}")
            set(resolved_property_value 0)
            set(resolved_property "${_property}")
        else ()
            if (${num_of_extra_args} LESS 1)
                message(WARNING "Expected board ID to be passed as an optional argument")
            else ()
                list(GET extra_args 0 board_id)
                _resolve_value("${property_value}" resolved_property_value ${board_id})
                if (quoted_property)
                    set(resolved_property "\"${property_name}${resolved_property_value}\"")
                else ()
                    set(resolved_property "${property_name}${resolved_property_value}")
                endif ()
            endif ()
        endif ()
    else ()
        if (${num_of_extra_args} LESS 1)
            message(WARNING "Expected board ID to be passed as an optional argument")
        else ()
            list(GET extra_args 0 board_id)
            _get_property_name("${_property}" property_name)
            _get_property_value("${_property}" property_value)
            _resolve_value("${property_value}" resolved_property_value ${board_id})
            set(resolved_property "${property_name}=${resolved_property_value}")
        endif ()
    endif ()

    # If value couldn't been resolved, return empty string
    if ("${resolved_property_value}" STREQUAL "")
        set(${_return_var} "" PARENT_SCOPE)
    else ()
        set(${_return_var} "${resolved_property}" PARENT_SCOPE)
    endif ()

endfunction()
