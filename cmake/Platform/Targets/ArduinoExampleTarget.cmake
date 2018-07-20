function(_find_example_sources _example_name _return_var)

    if (example_CATEGORY)
        set(search_path "${ARDUINO_SDK_EXAMPLES_PATH}/${example_CATEGORY}/${_example_name}.txt")
    else ()
        set(search_path "${ARDUINO_SDK_EXAMPLES_PATH}/${_example_name}.txt")
    endif ()
    file(GLOB_RECURSE example_description_file "${search_path}")
    get_filename_component(example_dir "${example_description_file}" DIRECTORY)

    find_sketch_files("${example_dir}" example_sketches)

    set(${_return_var} ${example_sketches} PARENT_SCOPE)

endfunction()

function(add_arduino_example _target_name _board_id _example_name)

    cmake_parse_arguments(example "" "CATEGORY" "" ${ARGN})

    _find_example_sources(${_example_name} example_sketches)
    foreach (sketch ${example_sketches})
        convert_sketch_to_source_file("${sketch}")
    endforeach ()

endfunction()
