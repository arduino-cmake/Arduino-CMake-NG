#=============================================================================#
# Finds source files matching the pre-defined source-file pattern under the given path.
# Search could also be recursive (With sub-directories) if the optional 'RECURSE' option is passed.
#        _base_path - Top-Directory path to search source files in.
#        _return_var - Name of variable in parent-scope holding the return value.
#        Returns - List of source files in the given path
#=============================================================================#
function(find_source_files _base_path _return_var)

    cmake_parse_arguments(source_file_search "RECURSE" "" "" ${ARGN})

    # Adapt the source files pattern to the given base dir
    set(current_pattern "")
    foreach (pattern ${ARDUINO_CMAKE_SOURCE_FILES_PATTERN})
        list(APPEND current_pattern "${_base_path}/${pattern}")
    endforeach ()

    if (${source_file_search_RECURSE})
        file(GLOB_RECURSE source_files ${current_pattern})
    else ()
        file(GLOB source_files LIST_DIRECTORIES FALSE ${current_pattern})
    endif ()

    set(${_return_var} "${source_files}" PARENT_SCOPE)

endfunction()

function(set_source_files_pattern)

    set(ARDUINO_CMAKE_SOURCE_FILES_PATTERN *.c *.cc *.cpp *.cxx *.[Ss] CACHE STRING
            "Source Files Pattern")

endfunction()
