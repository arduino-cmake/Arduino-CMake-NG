function(read_properties _properties_file_path)

    file(STRINGS ${_properties_file_path} properties)  # Settings file split into lines
    list(FILTER properties INCLUDE REGEX "^[^#]+=.*")

    foreach (property ${properties})
        _get_property_name(${property} property_name)
        string(REGEX MATCH "name" property_name_string_name "${property_name}")
        if (NOT ${property_name_string_name} STREQUAL "") # Property contains 'name' string
            continue() # Don't process further - Unnecessary information
        endif ()

        _get_property_value(${property} property_value)
        # Create a list if values are separated by spaces
        string(REPLACE " " ";" property_value "${property_value}")
        _resolve_value("${property_value}" resolved_property_value)

        string(REPLACE "." "_" property_cache_name ${property_name})
        set(${property_cache_name} ${resolved_property_value} CACHE STRING "")

    endforeach ()

endfunction()
