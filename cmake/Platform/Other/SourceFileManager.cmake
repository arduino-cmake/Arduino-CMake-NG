function(find_source_files _base_path _return_var)

    set(extra_args ${ARGN})
    list(LENGTH extra_args num_of_extra_args)
    if (${num_of_extra_args} GREATER 0)
        list(GET extra_args 0 recursive_search_input)
        string(TOLOWER "${recursive_search_input}" recursive_search_input)
        if ("${recursive_search_input}" STREQUAL "recurse")
            set(recursive_search TRUE)
        else ()
            set(recursive_search FALSE)
        endif ()
    endif ()

    # Adapt the source files pattern to the given base dir
    set(current_pattern "")
    foreach (pattern ${ARDUINO_CMAKE_SOURCE_FILES_PATTERN})
        list(APPEND current_pattern "${_base_path}/${pattern}")
    endforeach ()

    if (recursive_search)
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
