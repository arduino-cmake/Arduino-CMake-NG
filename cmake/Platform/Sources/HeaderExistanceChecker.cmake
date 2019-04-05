#=============================================================================#
# Checks whether the given header name is discoverable by the given target,
# i.e. whether it's part of the target's 'INCLUDE_DIRECTORIES' property.
#       _header_we - Name of a header to check its' discoverability.
#       _target_name - Name of a target to check discoverability against.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - True if discoverable, false otherwise.
#=============================================================================#
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
