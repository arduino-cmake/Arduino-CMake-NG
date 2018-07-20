function(convert_sketch_to_source_file _sketch_file)

    get_filename_component(sketch_file_name "${_sketch_file}" NAME_WE)
    set(target_source_path "${CMAKE_CURRENT_SOURCE_DIR}/${sketch_file_name}.cpp")

    file(STRINGS "${_sketch_file}" sketch_loc)
    list(LENGTH sketch_loc num_of_loc)
    decrement_integer(num_of_loc 1)

    set(refined_sketch)
    set(header_insert_pattern "^.+\\(.*\\)")
    set(header_inserted FALSE)

    foreach (loc_index RANGE 0 ${num_of_loc})
        list(GET sketch_loc ${loc_index} loc)
        if (NOT ${header_inserted})
            if ("${loc}" MATCHES "${header_insert_pattern}")
                # ToDo: Insert platform's main header file, found earlier when initializing platform
                decrement_integer(loc_index 1)
                list(INSERT refined_sketch ${loc_index} "#include <Arduino.h>\n\n")
                increment_integer(loc_index 1)
                set(header_inserted TRUE)
            endif ()
        endif ()
        if ("${loc}" STREQUAL "")
            list(APPEND refined_sketch "\n")
        else ()
            string(REGEX REPLACE "^(.+);(.*)$" "\\1${ARDUINO_CMAKE_SEMICOLON_REPLACEMENT}\\2"
                    refined_loc "${loc}")
            list(APPEND refined_sketch "${refined_loc}\n")
        endif ()
    endforeach ()

    file(WRITE ${target_source_path} "") # Clear previous file's contents
    foreach (refined_loc ${refined_sketch})
        string(REGEX REPLACE "^(.+)${ARDUINO_CMAKE_SEMICOLON_REPLACEMENT}(.*)$" "\\1;\\2"
                original_loc "${refined_loc}")
        file(APPEND ${target_source_path} "${original_loc}")
    endforeach ()

endfunction()
