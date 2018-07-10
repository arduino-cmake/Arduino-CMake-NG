function(get_platform_libraries_from_includes _include_locs _return_var)

    set(platform_libs)
    foreach (include ${_include_locs})
        string(REGEX MATCH "[\"<](.+)\\." include_name ${include})
        set(include_name "${CMAKE_MATCH_1}")
        string(TOLOWER "${include_name}" include_name_lower)
        if ("${include_name_lower}" IN_LIST ARDUINO_CMAKE_PLATFORM_LIBRARIES)
            list(APPEND platform_libs "${include_name}")
        else ()
            continue()
        endif ()
    endforeach ()

    set(${_return_var} ${platform_libs} PARENT_SCOPE)

endfunction()
