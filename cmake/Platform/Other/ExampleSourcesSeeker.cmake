function(_find_example_sources _base_path _example_name _search_extension _return_var)

    if (example_CATEGORY)
        set(search_path "${_base_path}/${example_CATEGORY}/${_example_name}.${_search_extension}")
    else ()
        set(search_path "${_base_path}/${_example_name}.${_search_extension}")
    endif ()
    file(GLOB_RECURSE example_description_file "${search_path}")
    get_filename_component(example_dir "${example_description_file}" DIRECTORY)

    find_sketch_files("${example_dir}" example_sketches)

    set(${_return_var} ${example_sketches} PARENT_SCOPE)

endfunction()

function(find_arduino_example_sources _base_path _example_name _return_var)

    # Example directories contain a '.txt' file along with all other sources
    _find_example_sources("${_base_path}" ${_example_name} "txt" sources)
    set(${_return_var} ${sources} PARENT_SCOPE)

endfunction()

function(find_arduino_library_example_sources _base_path _example_name _return_var)

    # Library example directories contain only '.ino' files
    _find_example_sources("${_base_path}" ${_example_name} "ino" sources)
    set(${_return_var} ${sources} PARENT_SCOPE)

endfunction()
