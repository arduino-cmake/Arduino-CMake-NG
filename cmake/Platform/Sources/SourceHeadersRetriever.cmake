#=============================================================================#
# Retrieves all headers included by a source file.
# Headers are returned by their name, with extension (such as '.h').
#       _source_file - Path to a source file to get its' included headers.
#       [WE] - Return headers without extension, just their names.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - List of headers names with extension that are included by the given source file.
#=============================================================================#
function(_get_source_included_headers _source_file _return_var)

    cmake_parse_arguments(parsed_args "WE" "" "" ${ARGN})

    file(STRINGS "${_source_file}" source_lines) # Loc = Lines of code

    list(FILTER source_lines INCLUDE REGEX ${ARDUINO_CMAKE_HEADER_INCLUDE_REGEX_PATTERN})

    # Extract header names from inclusion
    foreach (loc ${source_lines})

        string(REGEX MATCH ${ARDUINO_CMAKE_HEADER_NAME_REGEX_PATTERN} match ${loc})

        if (parsed_args_WE)
            get_name_without_file_extension("${CMAKE_MATCH_1}" header_name)
        else ()
            set(header_name ${CMAKE_MATCH_1})
        endif ()

        list(APPEND headers ${header_name})

    endforeach ()

    set(${_return_var} ${headers} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Retrieves all headers used by a source file, possibly recursively (Headers used by headers).
#       _source_file - Path to a source file to get its' used headers.
#       _search_dirs - List of directories where headers should be searched at.
#       [RECURSIVE] - Whether to search for headers recursively.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - List of full paths to the headers that are used by the given source file.
#=============================================================================#
function(get_source_headers _source_file _search_dirs _return_var)

    cmake_parse_arguments(parsed_args "RECURSIVE" "" "" ${ARGN})

    _get_source_included_headers(${_source_file} included_headers WE)

    foreach (header ${included_headers})

        get_header_file(${header} ${_search_dirs} header_path)
        if (NOT header_path OR "${header_path}" MATCHES "NOTFOUND")
            continue()
        endif ()

        list(APPEND final_included_headers ${header_path})

        if (parsed_args_RECURSIVE)
            get_source_headers(${header_path} ${_search_dirs} recursive_included_headers RECURSIVE)
            list(APPEND final_included_headers ${recursive_included_headers})
        endif ()

    endforeach ()

    if (final_included_headers)
        list(REMOVE_DUPLICATES final_included_headers)
    endif ()

    set(${_return_var} ${final_included_headers} PARENT_SCOPE)

endfunction()
