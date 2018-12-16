include(SourceSeeker)
include(ExampleSourcesSeeker)
include(ArduinoLibrarySourcesSeeker)

#=============================================================================#
# Appends all sources and headers under the given directory to the givne target.
# This could also be done recursively if the RECURSE option is provided.
#       _target_name - Name of the target which sources will be appended to.
#       [DIRS] - Indefinite list of directories which its' sources should be appended.
#       [RECURSE] - Whether search should be done recursively or not.
#                   This affects all given directories.
#=============================================================================#
function(target_source_directories _target_name)

    cmake_parse_arguments(parsed_args "RECURSE" "" "DIRS" ${ARGN})

    if (NOT TARGET ${_target_name})
        message(FATAL_ERROR "Can't add sources to the ${_target_name} target as it doesn't exist!")
    endif ()

    if (NOT parsed_args_DIRS)
        message(FATAL_ERROR "Source dirctories must be provided with the DIRS keyword before them!")
    endif ()

    set(source_dirs ${parsed_args_DIRS})

    list(REMOVE_DUPLICATES source_dirs)

    if (parsed_args_RECURSE) # Search recursively

        foreach (source_dir ${source_dirs})

            find_header_files(${source_dir} headers RECURSE)
            find_source_files(${source_dir} sources RECURSE)

            list(APPEND collective_headers ${headers})
            list(APPEND collective_sources ${sources})

        endforeach ()

    else ()
    
        foreach (source_dir ${source_dirs})

            find_header_files(${source_dir} headers)
            find_source_files(${source_dir} sources)

            list(APPEND collective_headers ${headers})
            list(APPEND collective_sources ${sources})

        endforeach ()

    endif ()

    if (collective_headers)
        list(REMOVE_DUPLICATES collective_headers)
    endif ()

    if (collective_sources)
        list(REMOVE_DUPLICATES collective_sources)
    endif ()

    # Treat headers' parent directories as include directories of the target
    get_headers_parent_directories("${collective_headers}" include_dirs)
    
    target_include_directories(${_target_name} PUBLIC ${include_dirs})

    target_sources(${_target_name} PUBLIC ${collective_sources})

endfunction()

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

    cmake_parse_arguments(headers "WE" "" "" ${ARGN})

    file(STRINGS "${_source_file}" source_lines) # Loc = Lines of code
    
    list(FILTER source_lines INCLUDE REGEX ${ARDUINO_CMAKE_HEADER_INCLUDE_REGEX_PATTERN})

    # Extract header names from inclusion
    foreach (loc ${source_lines})
        
        string(REGEX MATCH ${ARDUINO_CMAKE_HEADER_NAME_REGEX_PATTERN} match ${loc})
        
        if (headers_WE)
            get_name_without_file_extension("${CMAKE_MATCH_1}" header_name)
        else ()
            set(header_name ${CMAKE_MATCH_1})
        endif ()
        
        list(APPEND headers ${header_name})
    
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

    if (parent_dirs) # Check parent dirs, could be none if there aren't any headers amongst sources
        list(REMOVE_DUPLICATES parent_dirs)
    endif ()

    set(${_return_var} ${parent_dirs} PARENT_SCOPE)

endfunction()
