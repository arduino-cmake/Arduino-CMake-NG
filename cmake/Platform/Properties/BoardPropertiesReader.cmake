#=============================================================================#
# Gets valid board names from the given list of properties, which should be the properties read
# from the boards properties file.
# As the boards' names may contain spaces, their property name is returned instead of the value.
# That way, it's easier to treat them later as Cache variables.
#        _properties - List of properties that contains boards names.
#        _return_var - Name of variable in parent-scope holding the return value.
#        Returns - List of valid board names found in the given property-list.
#=============================================================================#
function(_get_boards_names _properties _return_var)

    list(FILTER _properties INCLUDE REGEX "name")

    set(__board_list)
    foreach (name_property ${_properties})
        string(REGEX MATCH "[^.]+" board_name "${name_property}")
        list(APPEND __board_list "${board_name}")
    endforeach ()
    list(REMOVE_DUPLICATES __board_list) # Remove possible duplicates

    set(ARDUINO_CMAKE_BOARDS ${__board_list} CACHE STRING "List of platform boards")

    set(${_return_var} ${__board_list} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Finds CPUs of each existing board that defines explciit ones.
# It means that boards such as 'nano' that define both the 'atmega168' and the 'atmega328' CPUs
# will define an appropriate Cache variable that stores the list of those CPUs for the given board.
#        _properties - List of properties that should be read from the boards properties file.
#        _boards - List of existing boards' names, found earlier with '_get_boards_names'
#=============================================================================#
function(_find_boards_cpus _properties _boards)

    list(FILTER _properties INCLUDE REGEX "^.+\\.menu\\.cpu\\.[^.]+=")
    foreach (cpu_property ${_properties})
        string(REGEX MATCH "^[^.]+" board_name "${cpu_property}")

        string(REGEX MATCH "[^.]+=" cpu_entry "${cpu_property}")
        string(LENGTH ${cpu_entry} cpu_entry_length)
        decrement_integer(cpu_entry_length 1)
        string(SUBSTRING ${cpu_entry} 0 ${cpu_entry_length} cpu)

        if (DEFINED __${board_name}_cpu_list)
            list(APPEND __${board_name}_cpu_list ${cpu})
        else ()
            set(__${board_name}_cpu_list ${cpu})
        endif ()
    endforeach ()

    foreach (board ${_boards})
        if (DEFINED __${board}_cpu_list)
            set(${board}_cpu_list ${__${board}_cpu_list} CACHE STRING "")
        endif ()
    endforeach ()

endfunction()

#=============================================================================#
# Property-reader function designed exclusively for the boards properties file.
# It's different since there are some processes which must be done in order to completely initialize
# the boards' properties.
#        _boards_properties_file - Full path to the boards properties file,
#                                  usually located under the platform directory.
#=============================================================================#
function(read_boards_properties _boards_properties_file)

    file(STRINGS ${_boards_properties_file} properties)
    read_properties("${properties}")

    _get_boards_names("${properties}" board_list)
    _find_boards_cpus("${properties}" "${board_list}")

endfunction()
