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

    string(REGEX MATCH "=" normal_property "${_property}")
    if ("${normal_property}" STREQUAL "") # Recipe property, doesn't have '='
        _get_recipe_property_name("${_property}" property_name)
        _get_recipe_property_value("${_property}" property_value)
        _resolve_value("${property_value}" resolved_property_value ${_board_id})
        set(resolved_property "${property_name}${resolved_property_value}")
    else ()
        _get_property_name("${_property}" property_name)
        _get_property_value("${_property}" property_value)
        _resolve_value("${property_value}" resolved_property_value ${_board_id})
        set(resolved_property "${property_name}=${resolved_property_value}")
    endif ()

    # If value couldn't been resolved, return empty string
    if ("${resolved_property_value}" STREQUAL "")
        set(${_return_var} "" PARENT_SCOPE)
    else ()
        set(${_return_var} "${resolved_property}" PARENT_SCOPE)
    endif ()

endfunction()

function(parse_compiler_recipe_flags _board_id _return_var)

    set(recipe_language cpp) # Use C++ by default
    set(final_recipe "")

    foreach (recipe_element ${recipe_cpp_o_pattern})
        string(REGEX MATCH "path|cmd" non_flag_element "${recipe_element}")
        if ("${non_flag_element}" STREQUAL "") # Element IS a flag, parse it
            # Element is wrapped with brackets = hasn't been resolved earlier and should be ommited
            string(REGEX MATCH "^[{\"].+[}\"]$" unresolved_element "${recipe_element}")
            if (NOT "${unresolved_element}" STREQUAL "") # Element is unresolved but should be
                continue()
            endif ()

            # Resolve element by searching it in the board's properties
            _resolve_recipe_property("${recipe_element}" resolved_element)
            if (NOT "${resolved_element}" STREQUAL "")
                list(APPEND final_recipe "${resolved_element}")
            endif ()
        endif ()
    endforeach ()

    set(${_return_var} "${final_recipe} " PARENT_SCOPE)

endfunction()
