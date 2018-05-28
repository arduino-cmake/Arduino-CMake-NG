function(read_properties _properties_file_path)

    file(STRINGS ${_properties_file_path} properties)  # Settings file split into lines

    foreach (property ${properties})
        if ("${property}" MATCHES "^[^#]+=.*")
            string(REGEX MATCH "^[^=]+" property_name ${property})
            string(REGEX MATCH "name" property_name_string_name ${property_name})
            if (NOT ${property_name_string_name} STREQUAL "")
                continue()
            endif ()
            string(REPLACE "." "_" property_separated_names ${property_name})

            # Allow for values to contain '='
            string(REGEX REPLACE "^[^=]+=(.*)" "\\1" property_value "${property}")
            string(STRIP "${property_value}" property_value)
            if ("${property_value}" STREQUAL "") # Empty value
                continue() # Don't store value - unnecessary
            endif ()
            string(REGEX REPLACE " " ";" property_value "${property_value}")

            set("${property_separated_names}" "${property_value}" CACHE STRING "")
        endif ()
    endforeach ()

endfunction()