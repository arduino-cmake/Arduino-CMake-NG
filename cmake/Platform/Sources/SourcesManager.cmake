include(SourceSeeker)
include(ExampleSourcesSeeker)

#=============================================================================#
# Gets all '#include' lines of the given source file.
#        _source_file - Source file to get its' includes.
#        _return_var - Name of variable in parent-scope holding the return value.
#        Returns - List of found include lines, if any.
#=============================================================================#
function(get_source_file_includes _source_file _return_var)

    if (NOT EXISTS "${_source_file}")
        message(SEND_ERROR "Can't find '#includes', source file doesn't exist: ${_source_file}")
    endif ()

    file(STRINGS "${_source_file}" source_lines)
    list(FILTER source_lines INCLUDE REGEX "${ARDUINO_CMAKE_HEADER_INCLUDE_REGEX_PATTERN}")

    set(${_return_var} ${source_lines} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Retrieves all headers includedby a source file. 
# Headers are returned by their name, with extension (such as '.h').
#       _source_file - Path to a source file to get its' included headers.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - List of headers names with extension that are included by the given source file.
#=============================================================================#
function(get_source_file_included_headers _source_file _return_var)

    file(STRINGS "${_source_file}" source_lines) # Loc = Lines of code
    list(FILTER source_lines INCLUDE REGEX ${ARDUINO_CMAKE_HEADER_INCLUDE_REGEX_PATTERN})

    # Extract header names from inclusion
    foreach (loc ${source_lines})
        string(REGEX MATCH ${ARDUINO_CMAKE_HEADER_NAME_REGEX_PATTERN} ${loc} match)
        list(APPEND headers ${CMAKE_MATCH_1})
    endforeach ()

    set(${_return_var} ${headers} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Gets paths of parent directories from all header files amongst the given sources.
# The list of paths is unique (without duplicates).
#        _sources - List of sources to get include directories from.
#        _return_var - Name of variable in parent-scope holding the return value.
#        Returns - List of directories representing the parent directories of all given headers.
#=============================================================================#
function(get_headers_parent_directories _sources _return_var)

    # Extract header files
    list(FILTER _sources INCLUDE REGEX "${ARDUINO_CMAKE_HEADER_FILE_EXTENSION_REGEX_PATTERN}")
    foreach (header_source ${_sources})
        get_filename_component(header_parent_dir ${header_source} DIRECTORY)
        list(APPEND parent_dirs ${header_parent_dir})
    endforeach ()
    list(REMOVE_DUPLICATES parent_dirs)

    set(${_return_var} ${parent_dirs} PARENT_SCOPE)

endfunction()
