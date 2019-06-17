#=============================================================================#
# Resolves all headers used by a given sketch file by searching its 'include lines', recursively.
#       _target_name - Name of the sketch's target created earlier.
#       _sketch_file - Path to the sketch file which its' headers should be resolved.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - List of all unique header files used by the sketch file, recursively.
#=============================================================================#
function(resolve_sketch_headers _target_name _sketch_file _return_var)

    get_target_include_directories(${_target_name} target_include_dirs)

    get_source_headers("${_sketch_file}" "${target_include_dirs}" sketch_headers RECURSIVE)
    get_source_headers("${ARDUINO_CMAKE_PLATFORM_HEADER_PATH}" "${target_include_dirs}" platform_headers RECURSIVE)

    list(APPEND sketch_headers ${platform_headers})

    if (sketch_headers)
        list(REMOVE_DUPLICATES sketch_headers)
    endif ()

    set(${_return_var} ${sketch_headers} PARENT_SCOPE)

endfunction()
