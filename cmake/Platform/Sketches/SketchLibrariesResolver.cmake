#=============================================================================#
# Resolves the header files included in a sketch by linking their appropriate library if necessary
# or by validating they're included by the sketch target.
#       _target_name - Name of the target to add the sketch file to.
#       _sketch_file - Path to a sketch file to add to the target.
#=============================================================================#
function(resolve_sketch_libraries _target_name _sketch_file)

    _get_source_included_headers("${_sketch_file}" sketch_headers)

    foreach (header ${sketch_headers})

        # Header name without extension (such as '.h') can represent an Arduino/Platform library
        # So first we should check whether it's a library
        get_name_without_file_extension("${header}" header_we)

        # Pass the '3RD_PARTY' option to avoid name-conversion
        find_arduino_library(${header_we}_sketch_lib ${header_we} 3RD_PARTY QUIET)

        if (TARGET ${header_we}_sketch_lib)
            link_arduino_library(${_target_name} ${header_we}_sketch_lib)
        endif ()

    endforeach ()

endfunction()
