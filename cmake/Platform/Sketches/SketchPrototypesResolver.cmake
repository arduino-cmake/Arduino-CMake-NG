function(resolve_sketch_prototypes _sketch_file _resolved_sketch_headers _return_var)

    get_source_function_definitions(${_sketch_file} sketch_func_defines)
    if (NOT sketch_func_defines) # Source has no function definitions at all
        return()
    endif ()

    list(APPEND _resolved_sketch_headers "${_sketch_file}")

    foreach (func_def ${sketch_func_defines})

        match_function_declaration("${func_def}" "${_resolved_sketch_headers}" match)

        if (${match} MATCHES "NOTFOUND")
            # ToDo: Append signature to list of prototypes to create
            message("Coludn't find a matching declaration for `${func_def}`")
        endif ()

    endforeach ()

endfunction()