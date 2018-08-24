function(get_sketch_libraries _sketch_file _return_var)

    file(STRINGS "${_sketch_file}" sketch_loc) # Loc = Lines of code
    list(FILTER sketch_loc INCLUDE REGEX ${ARDUINO_CMAKE_HEADER_INCLUDE_REGEX_PATTERN})

    # Extract header names from inclusion
    foreach (loc ${sketch_loc})
        string(REGEX MATCH ${ARDUINO_CMAKE_HEADER_NAME_REGEX_PATTERN} ${loc} match)
        list(APPEND libraries_names ${CMAKE_MATCH_1})
    endforeach ()

    set(${_return_var} ${libraries_names} PARENT_SCOPE)

endfunction()
