include(SketchPlatformHeaderInserter)
include(SketchLibraryFetcher)

#=============================================================================#
# Converts all the given sketch file into valid 'cpp' source files and returns their paths.
#        _sketch_files - List of paths to original sketch files.
#        _return_var - Name of variable in parent-scope holding the return value.
#        Returns - List of paths representing post-conversion sources.
#=============================================================================#
function(get_sources_from_sketches _sketch_files _return_var)

    set(sources)
    foreach (sketch ${_sketch_files})
        get_filename_component(sketch_file_name "${sketch}" NAME_WE)
        set(target_source_path "${CMAKE_CURRENT_SOURCE_DIR}/${sketch_file_name}.cpp")
        # Only convert sketch if it hasn't been converted yet
        if (NOT EXISTS "${target_source_path}")
            insert_platform_header_to_sketch("${sketch}" "${target_source_path}")
        endif ()
        list(APPEND sources "${target_source_path}")
    endforeach ()

    set(${_return_var} ${sources} PARENT_SCOPE)

endfunction()
