function(get_target_include_directories _target_name _return_var)

    # Get target's direct include dirs
    get_target_property(target_include_dirs ${_target_name} INCLUDE_DIRECTORIES)

    # Get include dirs of targets linked to the given target
    get_target_property(target_linked_libs ${_target_name} LINK_LIBRARIES)

    # Explictly add include dirs of all linked libraries (given they're valid cmake targets)
    foreach (linked_lib ${target_linked_libs})

        if (NOT TARGET ${linked_lib}) # Might be a command-line linked library (such as 'm'/math)
            continue()
        endif ()

        get_target_include_directories(${linked_lib} lib_include_dirs)
        set(include_dirs ${lib_include_dirs}) # Update list with recursive call results

    endforeach ()

    if (NOT "${target_include_dirs}" MATCHES "NOTFOUND") # Target has direct include dirs
        list(APPEND include_dirs ${target_include_dirs})
    endif ()

    list(REMOVE_DUPLICATES include_dirs)

    set(${_return_var} ${include_dirs} PARENT_SCOPE)

endfunction()
