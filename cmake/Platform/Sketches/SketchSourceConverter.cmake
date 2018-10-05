#=============================================================================#
# Writes the given lines of code belonging to the sketch to the given file path.
#        _sketch_loc - List of lines-of-code belonging to the sketch.
#        _file_path - Full path to the written source file.
#=============================================================================#
function(_write_source_file _sketch_loc _file_path)

    file(WRITE "${_file_path}" "") # Clear previous file's contents

    foreach (loc ${_sketch_loc})

        string(REGEX REPLACE "^(.+)${ARDUINO_CMAKE_SEMICOLON_REPLACEMENT}(.*)$" "\\1;\\2"
                original_loc "${loc}")

        file(APPEND "${_file_path}" "${original_loc}")

    endforeach ()

endfunction()

#=============================================================================#
# Finds the best line to insert an '#include' of the platform's main header to.
# The function assumes that the initial state of the given 'active index' is set to the line that
# best fitted the insertion, however, it might need a bit more optimization. Why?
# Because above those lines there might be a comment, or a comment block,
# all of which should be taken into account in order to minimize the effect on code's readability.
#        _sketch_loc - List of lines-of-code belonging to the sketch.
#        _active_index - Index that indicates the best-not-optimized loc to insert header to.
#        _return_var - Name of variable in parent-scope holding the return value.
#        Returns - Best fitted index to insert platform's main header '#include' to.
#=============================================================================#
function(_get_matching_header_insertion_index _sketch_loc _active_index _return_var)

    if (${_active_index} EQUAL 0) # First line in a file will always result in the 1st index
        set(${_return_var} 0 PARENT_SCOPE)
        return()
    else ()
        decrement_integer(_active_index 1)
    endif ()

    list(GET _sketch_loc ${_active_index} previous_loc)

    if ("${previous_loc}" MATCHES "^//") # Simple one-line comment
        set(matching_index ${_active_index})

    elseif ("${previous_loc}" MATCHES "\\*/$") # End of multi-line comment

        foreach (index RANGE ${_active_index} 0)

            list(GET _sketch_loc ${index} multi_comment_line)

            if ("${multi_comment_line}" MATCHES "^\\/\\*") # Start of multi-line comment
                set(matching_index ${index})
                break()
            endif ()

        endforeach ()

    else () # Previous line isn't a comment - Return original index

        increment_integer(_active_index 1)
        set(matching_index ${_active_index})

    endif ()

    set(${_return_var} ${matching_index} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Converts the given sketch file into a valid 'cpp' source file under the project's working dir.
# During the conversion process the platform's main header file is inserted to the source file
# since it's critical for it to include it - Something that doesn't happen in "Standard" sketches.
#        _sketch_file - Full path to the original sketch file (Read from).
#        _converted_source_path - Full path to the converted target source file (Written to).
#=============================================================================#
function(convert_sketch_to_source _sketch_file _converted_source_path)

    file(STRINGS "${_sketch_file}" sketch_loc)

    list(LENGTH sketch_loc num_of_loc)
    decrement_integer(num_of_loc 1)

    set(refined_sketch)
    set(header_inserted FALSE)

    set(header_insert_pattern
            "${ARDUINO_CMAKE_HEADER_INCLUDE_REGEX_PATTERN}|${ARDUINO_CMAKE_FUNCTION_REGEX_PATTERN}")
    set(include_line "#include <${ARDUINO_CMAKE_PLATFORM_HEADER_NAME}>")

    foreach (loc_index RANGE 0 ${num_of_loc})

        list(GET sketch_loc ${loc_index} loc)

        if (NOT ${header_inserted})

            if ("${loc}" MATCHES "${header_insert_pattern}")

                _get_matching_header_insertion_index("${sketch_loc}" ${loc_index} header_index)

                if (${header_index} LESS ${loc_index})
                    set(formatted_include_line ${include_line} "\n\n")

                elseif (${header_index} EQUAL 0)
                    set(formatted_include_line ${include_line} "\n")

                else ()

                    set(formatted_include_line "\n" ${include_line})

                    if (${header_index} GREATER_EQUAL ${loc_index})

                        decrement_integer(header_index 1)

                        string(APPEND formatted_include_line "\n")

                    endif ()

                endif ()

                list(INSERT refined_sketch ${header_index} ${formatted_include_line})

                set(header_inserted TRUE)

            endif ()

        endif ()

        if ("${loc}" STREQUAL "")
            list(APPEND refined_sketch "\n")
        else ()

            string(REGEX REPLACE "^(.+);(.*)$" "\\1${ARDUINO_CMAKE_SEMICOLON_REPLACEMENT}\\2"
                    refined_loc "${loc}")

            list(APPEND refined_sketch "${refined_loc}\n")

        endif ()

    endforeach ()

    _write_source_file("${refined_sketch}" "${_converted_source_path}")

endfunction()
