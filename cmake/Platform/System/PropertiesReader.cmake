function(_resolve_entry_link _entry _return_var)

    string(REGEX REPLACE "^{(.+)}$" "\\1" _entry "${_entry}")
    string(REPLACE "Platform" "_" _entry "${_entry}")
    if (DEFINED ${_entry})
        set(${_return_var} "${${_entry}}" PARENT_SCOPE)
    endif ()

endfunction()

function(_resolve_property_value_links _property_value _return_var)

    set(index 0)
    foreach (property_value_entry ${_property_value})

        string(REGEX MATCH "^{.+}$" entry_link "${property_value_entry}")
        if ("${entry_link}" STREQUAL "") # Entry is not a link
            increment_integer(index 1)
        else ()
            _resolve_entry_link("${entry_link}" resolved_entry)
            if (NOT "${resolved_entry}" STREQUAL "")
                list_replace("${_property_value}" ${index} "${resolved_entry}" _property_value)
            endif ()
        endif ()

    endforeach ()

    set(${_return_var} "${_property_value}" PARENT_SCOPE)

endfunction()

function(read_properties _properties_file_path)

    file(STRINGS ${_properties_file_path} properties)  # Settings file split into lines
    list(FILTER properties INCLUDE REGEX "^[^#]+=.*")

    foreach (property ${properties})
        string(REGEX MATCH "^[^=]+" property_name "${property}")
        string(REGEX MATCH "name" property_name_string_name "${property_name}")
        if (NOT ${property_name_string_name} STREQUAL "") # Property contains 'name' string
            continue() # Don't process further - Unnecessary information
        endif ()
        string(REPLACE "Platform" "_" property_separated_names ${property_name})

        # Allow for values to contain '='
        string(REGEX REPLACE "^[^=]+=(.*)" "\\1" property_value "${property}")
        string(STRIP "${property_value}" property_value)
        if ("${property_value}" STREQUAL "") # Empty value
            continue() # Don't store value - unnecessary
        endif ()
        string(REPLACE " " ";" property_value "${property_value}")
        _resolve_property_value_links("${property_value}" resolved_property_value)

        set("${property_separated_names}" "${resolved_property_value}" CACHE STRING "")
    endforeach ()

endfunction()
