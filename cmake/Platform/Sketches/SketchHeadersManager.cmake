#=============================================================================#
# Resolves the header files included in a sketch by linking their appropriate library if necessary
# or by validating they're included by the sketch target.
#       _target_name - Name of the target to add the sketch file to.
#       _sketch_file - Path to a sketch file to add to the target.
#=============================================================================#
function(resolve_sketch_headers _target_name _sketch_file)

    get_source_file_included_headers("${_sketch_file}" sketch_headers)

    foreach (header ${sketch_headers})

        # Header name without extension (such as '.h') can represent an Arduino/Platform library
        # So first we should check whether it's a library
        get_name_without_file_extension("${header}" header_we)

        is_platform_library(${header_we} is_header_platform_lib)

        if (is_header_platform_lib)

            string(TOLOWER ${header_we} header_we_lower)

            link_platform_library(${_target_name} ${header_we_lower})

        else ()

            # Pass the '3RD_PARTY' option to avoid name-conversion
            find_arduino_library(${header_we}_sketch_lib ${header_we} 3RD_PARTY QUIET)

            # If library isn't found, display a status since it might be a user library
            if (NOT TARGET ${header_we}_sketch_lib OR
                    "${${header_we}_sketch_lib}" MATCHES "NOTFOUND")

                message(STATUS "The header '${header_we}' is used by the '${_sketch_file}' sketch, "
                        "but it isn't part of an Arduino nor a Platform library.\n\t"
                        "However, it may be part of a user library but "
                        "you'd have to check this manually!")

            else ()
                link_arduino_library(${_target_name} ${header_we}_sketch_lib)
            endif ()

        endif ()

    endforeach ()

endfunction()
