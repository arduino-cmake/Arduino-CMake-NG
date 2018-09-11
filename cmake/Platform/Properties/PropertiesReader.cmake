function(read_properties _properties_list)

    list(FILTER _properties_list INCLUDE REGEX "^[^#]+=.*")

    foreach (property ${_properties_list})
        _get_property_name(${property} property_name)
        if ("${property_name}" MATCHES "name") # Property contains 'name' string
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

function(read_properties_from_file _properties_file_path)

    file(STRINGS ${_properties_file_path} properties)
    read_properties("${properties}")

endfunction()
