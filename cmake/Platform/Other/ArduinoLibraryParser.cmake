function(find_dependent_platform_libraries _return_var)

    set(sources ${ARGN})

    set(includes)
    foreach (source ${sources})
        get_source_file_includes(${source} source_includes)
        list(APPEND includes ${source_includes})
    endforeach ()

    set(dependent_libs)
    list(REMOVE_DUPLICATES includes)
    foreach (include ${includes})
        string(REGEX REPLACE "[\"<](.+)\\." "\\1" include_name ${include})
        string(TOLOWER ${include_name} include_name)
        list(FIND ARDUINO_CMAKE_PLATFORM_LIBRARIES ${include_name} platform_lib_index)
        if (${platform_lib_index} LESS 0)
            continue()
        else ()
            list(APPEND dependent_libs ${include_name})
        endif ()
    endforeach ()

    set(${_return_var} ${dependent_libs} PARENT_SCOPE)

endfunction()
