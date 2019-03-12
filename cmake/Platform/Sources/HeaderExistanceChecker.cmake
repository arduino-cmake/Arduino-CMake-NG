function(_check_header_existance _header_we _dir_list _return_var)

    foreach (include_dir ${_dir_list})

        find_header_files("${include_dir}" include_dir_headers RECURSE)

        foreach (included_header ${include_dir_headers})
            get_name_without_file_extension(${included_header} included_header_we)
            if ("${included_header_we}" STREQUAL "${_header_we}")
                set(_return_var ${included_header} PARENT_SCOPE)
                return()
            endif ()
        endforeach ()

    endforeach ()

    set(_return_var NOTFOUND PARENT_SCOPE)

endfunction()

function(is_header_discoverable_by_target _header_we _target_name _return_var)

    # Get target's direct include dirs
    get_target_property(target_include_dirs ${_target_name} INCLUDE_DIRECTORIES)

    # Get include dirs of targets linked to the given target
    get_target_property(target_linked_libs ${_target_name} LINK_LIBRARIES)

    # Explictly add include dirs of all linked libraries (given they're valid cmake targets)
    foreach (linked_lib ${target_linked_libs})

        if (NOT TARGET ${linked_lib})
            continue()
        endif ()

        get_target_property(lib_include_dirs ${linked_lib} INCLUDE_DIRECTORIES)
        if (NOT "${lib_include_dirs}" MATCHES "NOTFOUND") # Library has include dirs
            list(APPEND include_dirs ${lib_include_dirs})
        endif ()

    endforeach ()

    if (NOT "${target_include_dirs}" MATCHES "NOTFOUND") # Target has direct include dirs
        list(APPEND include_dirs ${target_include_dirs})
    endif ()

    _check_header_existance(${_header_we} ${include_dirs} header_found)

    set(_return_var ${header_found} PARENT_SCOPE)

endfunction()
