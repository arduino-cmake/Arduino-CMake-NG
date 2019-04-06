#=============================================================================#
# Resolves the libraries used by a sketch file. It's possible that not all libraries will be resolved,
# as the current algorithm relies on the name of the included headers to match a library name.
#       _target_name - Name of the sketch's target created earlier.
#       _sketch_file - Path to the sketch file which its' libraries should be resolved.
#       _sketch_headers - List of headers files used by the sketch, directly or indirectly.
#=============================================================================#
function(resolve_sketch_libraries _target_name _sketch_file _sketch_headers)

    foreach (header ${_sketch_headers})

        # Header name without extension (such as '.h') can represent an Arduino/Platform library
        get_name_without_file_extension("${header}" header_we)

        # Pass the '3RD_PARTY' option to avoid name-conversion
        find_arduino_library(${header_we}_sketch_lib ${header_we} 3RD_PARTY QUIET)

        if (TARGET ${header_we}_sketch_lib)
            link_arduino_library(${_target_name} ${header_we}_sketch_lib)
        endif ()

    endforeach ()

endfunction()
