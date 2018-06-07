function(read_boards_properties _boards_properties_file)

    file(STRINGS ${_boards_properties_file} properties)  # Settings file split into lines
    list(FILTER properties INCLUDE REGEX "^[^#]+=.*")

    foreach (property ${properties})
        _get_property_name(${property} property_name)
        string(REGEX MATCH "name" property_name_string_name "${property_name}")
        if (NOT ${property_name_string_name} STREQUAL "") # Property contains 'name' string
            string(REGEX MATCH "[^.]+" board_name "${property_name}")
            if (board_list)
                list(APPEND board_list ${board_name})
            else ()
                set(board_list ${board_name})
            endif ()
            continue() # Don't process further - Unnecessary information
        endif ()

        _get_property_value(${property} property_value)
        # Create a list if values are separated by spaces
        string(REPLACE " " ";" property_value "${property_value}")
        _resolve_value("${property_value}" resolved_property_value)

        string(REPLACE "." "_" property_cache_name ${property_name})
        set(${property_cache_name} ${resolved_property_value} CACHE STRING "")
    endforeach ()

    list(REMOVE_DUPLICATES board_list) # Remove possible duplicates
    set(ARDUINO_CMAKE_BOARDS ${board_list} CACHE STRING "List of platform boards")

    list(FILTER properties INCLUDE REGEX "^.+\\.menu\\.cpu\\.[^.]+=")
    foreach (cpu_property ${properties})
        string(REGEX MATCH "^[^.]+" board_name "${cpu_property}")

        string(REGEX MATCH "[^.]+=" cpu_entry "${cpu_property}")
        string(LENGTH ${cpu_entry} cpu_entry_length)
        math(EXPR cpu_entry_length ${cpu_entry_length}-1)
        string(SUBSTRING ${cpu_entry} 0 ${cpu_entry_length} cpu)

        if (DEFINED __${board_name}_cpu_list)
            list(APPEND __${board_name}_cpu_list ${cpu})
        else ()
            set(__${board_name}_cpu_list ${cpu})
        endif ()
    endforeach ()

    foreach (board ${board_list})
        if (DEFINED __${board}_cpu_list)
            set(${board}_cpu_list ${__${board}_cpu_list} CACHE STRING "")
        endif ()
    endforeach ()

endfunction()
