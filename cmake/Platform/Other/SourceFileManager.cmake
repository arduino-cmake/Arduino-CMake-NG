#=============================================================================#
# Finds source files matching the given pattern under the given path.
# Search could also be recursive (With sub-directories) if the optional 'RECURSE' option is passed.
#        _base_path - Top-Directory path to search source files in.
#        _return_var - Name of variable in parent-scope holding the return value.
#        Returns - List of sources in the given path
#=============================================================================#
function(_find_sources _base_path _pattern _return_var)

    cmake_parse_arguments(source_file_search "RECURSE" "" "" ${ARGN})

    # Adapt the source files pattern to the given base dir
    set(current_pattern "")
    foreach (pattern_part ${_pattern})
        list(APPEND current_pattern "${_base_path}/${pattern_part}")
    endforeach ()

    if (${source_file_search_RECURSE})
        file(GLOB_RECURSE source_files ${current_pattern})
    else ()
        file(GLOB source_files LIST_DIRECTORIES FALSE ${current_pattern})
    endif ()

    set(${_return_var} "${source_files}" PARENT_SCOPE)

endfunction()

#=============================================================================#
# Finds source files matching the pre-defined source-file pattern under the given path.
# This functions searchs explicitly for source-files such as '*.c'.
# Search could also be recursive (With sub-directories) if the optional 'RECURSE' option is passed.
#        _base_path - Top-Directory path to search source files in.
#        _return_var - Name of variable in parent-scope holding the return value.
#        Returns - List of source files in the given path
#=============================================================================#
function(find_source_files _base_path _return_var)

    _find_sources("${_base_path}" "${ARDUINO_CMAKE_SOURCE_FILES_PATTERN}" sources ${ARGN})
    set(${_return_var} "${sources}" PARENT_SCOPE)

endfunction()

#=============================================================================#
# Finds header files matching the pre-defined header-file pattern under the given path.
# This functions searchs explicitly for header-files such as '*.h'.
# Search could also be recursive (With sub-directories) if the optional 'RECURSE' option is passed.
#        _base_path - Top-Directory path to search source files in.
#        _return_var - Name of variable in parent-scope holding the return value.
#        Returns - List of header files in the given path
#=============================================================================#
function(find_header_files _base_path _return_var)

    _find_sources("${_base_path}" "${ARDUINO_CMAKE_HEADER_FILES_PATTERN}" headers ${ARGN})
    set(${_return_var} "${headers}" PARENT_SCOPE)

endfunction()

#=============================================================================#
# Sets a pre-defined source and header file patterns to use when searching for sources.
#=============================================================================#
function(set_source_files_pattern)

    set(ARDUINO_CMAKE_SOURCE_FILES_PATTERN *.c *.cc *.cpp *.cxx *.[Ss] CACHE STRING
            "Source Files Pattern")
    set(ARDUINO_CMAKE_HEADER_FILES_PATTERN *.h *.hh *.hpp *.hxx CACHE STRING
            "Header Files Pattern")

endfunction()

function(get_source_file_includes _source_file _return_var)

    if (NOT EXISTS "${_source_file}")
        message(SEND_ERROR "Can't find includs, source file doesn't exist: ${_source_file}")
    endif ()

    file(STRINGS ${_source_file} locs)
    list(FILTER locs INCLUDE REGEX "^#.+[\">]$")

    set(${_return_var} ${locs} PARENT_SCOPE)

endfunction()
