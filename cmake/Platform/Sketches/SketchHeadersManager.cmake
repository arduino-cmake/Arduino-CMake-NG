function(get_sketch_headers _sketch_file _return_var)

    file(STRINGS "${_sketch_file}" sketch_loc) # Loc = Lines of code
    list(FILTER sketch_loc INCLUDE REGEX ${ARDUINO_CMAKE_HEADER_INCLUDE_REGEX_PATTERN})

    # Extract header names from inclusion
    foreach (loc ${sketch_loc})
        string(REGEX MATCH ${ARDUINO_CMAKE_HEADER_NAME_REGEX_PATTERN} ${loc} match)
        list(APPEND headers ${CMAKE_MATCH_1})
    endforeach ()

    set(${_return_var} ${headers} PARENT_SCOPE)

endfunction()

function(validate_header_against_target _target_name _header _return_var)

    get_target_property(target_include_dirs ${_target_name} INCLUDE_DIRECTORIES)
    foreach (include_dir ${target_include_dirs})
        find_header_files("${include_dir}" include_dir_headers)
        if (${_header} IN_LIST include_dir_headers) # Header is included in the target
            set(${_return_var} True)
            return()
        endif ()
    endforeach ()

    set(${_return_var} False)

endfunction()
