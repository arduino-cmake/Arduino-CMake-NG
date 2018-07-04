function(_get_platform_libraries_from_includes _include_locs _return_var)

    set(platform_libs)
    foreach (include ${_include_locs})
        string(REGEX REPLACE "[\"<](.+)\\." "\\1" include_name ${include})
        string(TOLOWER ${include_name} include_name)
        if (${include_name} IN_LIST ARDUINO_CMAKE_PLATFORM_LIBRARIES)
            list(APPEND platform_libs ${include_name})
        else ()
            continue()
        endif ()
    endforeach ()

    set(${_return_var} ${platform_libs} PARENT_SCOPE)

endfunction()

function(find_dependent_platform_libraries _return_var)

    set(sources ${ARGN})

    set(includes)
    foreach (source ${sources})
        get_source_file_includes(${source} source_includes)
        list(APPEND includes ${source_includes})
    endforeach ()

    list(REMOVE_DUPLICATES includes)
    _get_platform_libraries_from_includes("${includes}" dependent_libs)

    set(${_return_var} ${dependent_libs} PARENT_SCOPE)

endfunction()
