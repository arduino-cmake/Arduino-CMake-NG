#=============================================================================#
# Writes the given lines of code belonging to the sketch to the given file path.
#        _sketch_lines - List of lines-of-code belonging to the sketch.
#        _file_path - Full path to the written source file.
#=============================================================================#
function(_write_source_file _sketch_lines _file_path)

    file(WRITE "${_file_path}" "") # Clear previous file's contents

    foreach (line ${_sketch_lines})
        escape_semicolon_in_string("${line}" original_line REVERSE)
        file(APPEND "${_file_path}" "${original_line}")
    endforeach ()

endfunction()

#=============================================================================#
# Finds the best line to insert an '#include' of the platform's main header to.
# The function assumes that the initial state of the given 'active index' is set to the line that
# best fitted the insertion, however, it might need a bit more optimization. Why?
# Because above those lines there might be a comment, or a comment block,
# all of which should be taken into account in order to minimize the effect on code's readability.
#        _sketch_lines - List of lines-of-code belonging to the sketch.
#        _active_index - Index that indicates the best-not-optimized line to insert header to.
#        _return_var - Name of variable in parent-scope holding the return value.
#        Returns - Best fitted index to insert platform's main header '#include' to.
#=============================================================================#
function(_get_matching_header_insertion_index _sketch_lines _active_index _return_var)

    if (${_active_index} EQUAL 0) # First line in a file will always result in the 1st index
        set(${_return_var} 0 PARENT_SCOPE)
        return()
    else ()
        decrement_integer(_active_index 1)
    endif ()

    list(GET _sketch_lines ${_active_index} previous_loc)

    if ("${previous_loc}" MATCHES "^//") # Simple one-line comment
        set(matching_index ${_active_index})
    elseif ("${previous_loc}" MATCHES "\\*/$") # End of multi-line comment

        foreach (index RANGE ${_active_index} 0)
            list(GET _sketch_lines ${index} multi_comment_line)

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
# Inline macro which handles the process of inserting a line including the platform header.
#        _sketch_lines - List of code lines read from the converted sketch file.
#        _insertion_line_index - Index of a code line at which the header should be inserted
#=============================================================================#
macro(_insert_line _inserted_line _sketch_lines _insertion_line_index)

    _get_matching_header_insertion_index("${_sketch_lines}" ${_insertion_line_index} header_index)

    if (${header_index} LESS ${_insertion_line_index})
        set(formatted_include_line ${_inserted_line} "\n\n")
    elseif (${header_index} EQUAL 0)
        set(formatted_include_line ${_inserted_line} "\n")
    else ()
        set(formatted_include_line "\n" ${_inserted_line})

        if (${header_index} GREATER_EQUAL ${_insertion_line_index})
            decrement_integer(header_index 1)
            string(APPEND formatted_include_line "\n")
        endif ()
    endif ()

    list(INSERT converted_source ${header_index} ${formatted_include_line})

endmacro()

macro(_insert_prototypes _prototypes _sketch_lines _insertion_line_index)

    foreach (prototype ${_prototypes})
        # Add semicolon ';' to make it a declaration
        escape_semicolon_in_string("${prototype};" formatted_prototype)

        _insert_line("${formatted_prototype}" "${sketch_lines}" ${line_index})
        increment_integer(_insertion_line_index 1)
    endforeach ()

endmacro()

#=============================================================================#
# Converts the given sketch file into a valid 'cpp' source file under the project's working dir.
# During the conversion process the platform's main header file is inserted to the source file
# since it's critical for it to include it - Something that doesn't happen in "Standard" sketches.
#       _sketch_file - Full path to the original sketch file (Read from).
#       _converted_source_path - Full path to the converted target source file (Written to).
#       _sketch_prototypes - List of prototypes to genereate, i.e. function definitions without a declaration.
#=============================================================================#
function(convert_sketch_to_source _sketch_file _converted_source_path _sketch_prototypes)

    file(STRINGS "${_sketch_file}" sketch_lines)

    set(function_prototype_pattern
            "${ARDUINO_CMAKE_FUNCTION_DECLARATION_REGEX_PATTERN}|${ARDUINO_CMAKE_FUNCTION_DEFINITION_REGEX_PATTERN}")
    set(header_insert_pattern
            "${ARDUINO_CMAKE_HEADER_INCLUDE_REGEX_PATTERN}|${function_prototype_pattern}")

    set(header_inserted FALSE)
    set(prototypes_inserted FALSE)

    list_max_index("${sketch_lines}" lines_count)
    #[[list(LENGTH sketch_lines lines_count)
    decrement_integer(lines_count 1)]]

    foreach (line_index RANGE ${lines_count})

        list(GET sketch_lines ${line_index} line)

        if (NOT ${header_inserted})
            if ("${line}" MATCHES "${header_insert_pattern}")
                _insert_line("${ARDUINO_CMAKE_PLATFORM_HEADER_INCLUDE_LINE}" "${sketch_lines}" ${line_index})
                set(header_inserted TRUE)
            endif ()
        elseif (NOT ${prototypes_inserted} AND "${line}" MATCHES "${function_prototype_pattern}")
            _insert_prototypes("${_sketch_prototypes}" "${sketch_lines}" ${line_index})
            set(prototypes_inserted TRUE)
        endif ()

        if ("${line}" STREQUAL "")
            list(APPEND converted_source "\n")
        else ()
            escape_semicolon_in_string("${line}" formatted_line)
            list(APPEND converted_source "${formatted_line}\n")
        endif ()

    endforeach ()

    _write_source_file("${converted_source}" "${_converted_source_path}")

endfunction()
