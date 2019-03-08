function(_check_header_existance _header_we _dir_list _return_var)

    foreach (include_dir ${_dir_list})
        find_header_files("${include_dir}" include_dir_headers RECURSE)

        foreach (included_header ${include_dir_headers})
            get_name_without_file_extension(${included_header} included_header_we)
            if ("${included_header_we}" STREQUAL "${_header_we}")
                set(_return_var TRUE PARENT_SCOPE)
                return()
            endif ()
        endforeach ()

    endforeach ()

    set(_return_var FALSE PARENT_SCOPE)

endfunction()

function(_is_known_header _header_we _target_name _return_var)

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

        # Pass the '3RD_PARTY' option to avoid name-conversion
        find_arduino_library(${header_we}_sketch_lib ${header_we} 3RD_PARTY QUIET)

        if (NOT TARGET ${header_we}_sketch_lib OR "${${header_we}_sketch_lib}" MATCHES "NOTFOUND")

            # The header name doesn't conform to a name of a known library, search individual headers instead
            _is_known_header(${header_we} ${_target_name} known_header)

            if (NOT ${known_header})
                message(STATUS "The '${header_we}' header used by the '${_sketch_file}' sketch can't be resolved. "
                        "It's probably a user-header which location is unknown to the framework.")
            endif ()

        else ()
            link_arduino_library(${_target_name} ${header_we}_sketch_lib)
        endif ()

    endforeach ()

endfunction()
