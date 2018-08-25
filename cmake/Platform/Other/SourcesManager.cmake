include(SketchManager)
include(ExampleSourcesSeeker)

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
# Finds sketch files matching the pre-defined sketch-file pattern under the given path.
# This functions searchs explicitly for sketch-files such as '*.ino'.
# Search could also be recursive (With sub-directories) if the optional 'RECURSE' option is passed.
#        _base_path - Top-Directory path to search source files in.
#        _return_var - Name of variable in parent-scope holding the return value.
#        Returns - List of header files in the given path
#=============================================================================#
function(find_sketch_files _base_path _return_var)

    _find_sources("${_base_path}" "${ARDUINO_CMAKE_SKETCH_FILES_PATTERN}" sketches ${ARGN})
    set(${_return_var} "${sketches}" PARENT_SCOPE)

endfunction()

#=============================================================================#
# Gets all '#include' lines of the given source file.
#        _source_file - Source file to get its' includes.
#        _return_var - Name of variable in parent-scope holding the return value.
#        Returns - List of found include lines, if any.
#=============================================================================#
function(get_source_file_includes _source_file _return_var)

    if (NOT EXISTS "${_source_file}")
        message(SEND_ERROR "Can't find includs, source file doesn't exist: ${_source_file}")
    endif ()

    file(STRINGS ${_source_file} locs)
    list(FILTER locs INCLUDE REGEX "^#.+[\">]$")

    set(${_return_var} ${locs} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Gets paths of parent directories from all header files amongst the given sources.
# The list of paths is unique and doesn't have duplicates, and represents a target's include dir.
#        _sources - List of sources to get include directories from.
#        _return_var - Name of variable in parent-scope holding the return value.
#        Returns - List of directories representing a target's include dir, from given headers.
#=============================================================================#
function(get_include_directories _sources _return_var)

    set(include_dirs)
    list(FILTER _sources INCLUDE REGEX ".+\\.h.*$") # Extract header files
    foreach (header_source ${_sources})
        get_filename_component(header_parent_dir ${header_source} DIRECTORY)
        list(APPEND include_dirs ${header_parent_dir})
    endforeach ()
    list(REMOVE_DUPLICATES include_dirs)

    set(${_return_var} ${include_dirs} PARENT_SCOPE)

endfunction()
