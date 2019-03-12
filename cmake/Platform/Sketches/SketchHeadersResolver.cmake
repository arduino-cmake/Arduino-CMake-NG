#=============================================================================#
# Resolves the header files included in a sketch by linking their appropriate library if necessary
# or by validating they're included by the sketch target.
#       _target_name - Name of the target to add the sketch file to.
#       _sketch_file - Path to a sketch file to add to the target.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - List of all unique header files used by the sketch file, recursively.
#=============================================================================#
function(resolve_sketch_headers _target_name _sketch_file _return_var)

    _get_source_included_headers("${_sketch_file}" sketch_headers)

    foreach (header ${sketch_headers})

        # Header name without extension (such as '.h') can represent an Arduino/Platform library
        # So first we should check whether it's a library
        get_name_without_file_extension("${header}" header_we)

        is_header_discoverable_by_target(${header_we} ${_target_name} known_header)

        if (NOT ${known_header})
            message(STATUS "The '${header_we}' header used by the '${_sketch_file}' sketch can't be resolved. "
                    "It's probably a user-header which location is unknown to the framework.")
        endif ()

    endforeach ()

endfunction()
