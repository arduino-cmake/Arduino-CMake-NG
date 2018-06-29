function(read_boards_properties _boards_properties_file)

    file(STRINGS ${_boards_properties_file} properties)
    read_properties("${properties}")

    list(FILTER properties INCLUDE REGEX "name")

    set(board_list)
    foreach (name_property ${properties})
        string(REGEX MATCH "[^.]+" board_name "${name_property}")
        list(APPEND board_list "${board_name}")
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
