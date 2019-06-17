#=============================================================================#
# Resolves the given sketch file's prototypes, which are just function declarations, 
# by matching all function definitions with their declaration. If a declaration can't be found, 
# the definition is added to a list of prototypes to generate, which is then returned.
#       _sketch_file - Path to the sketch file which its' libraries should be resolved.
#       _sketch_headers - List of headers files used by the sketch, directly or indirectly.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - List of prototypes to generate, i.e. function definitions without a matching declaration.
#=============================================================================#
function(resolve_sketch_prototypes _sketch_file _sketch_headers _return_var)

    get_source_function_definitions(${_sketch_file} sketch_func_defines)
    if (NOT sketch_func_defines) # Source has no function definitions at all
        return()
    endif ()

    # Add the current file to the list of headers to search in as well - It's the functions' containing file
    list(APPEND _sketch_headers "${_sketch_file}")

    foreach (func_def ${sketch_func_defines})

        match_function_declaration("${func_def}" "${_sketch_headers}" match)

        if (${match} MATCHES "NOTFOUND")
            list(APPEND prototypes "${func_def}")
        endif ()

    endforeach ()

    set(${_return_var} ${prototypes} PARENT_SCOPE)

endfunction()