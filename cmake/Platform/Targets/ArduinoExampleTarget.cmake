function(add_arduino_example _target_name _board_id _example_name)

    find_arduino_example_sources("${ARDUINO_SDK_EXAMPLES_PATH}"
            ${_example_name} example_sketches ${ARGN})
    get_sources_from_sketches("${example_sketches}" example_sources)
    message("Example sources: ${example_sources}")
    add_arduino_executable(${_target_name} ${_board_id} ${example_sources})

endfunction()

function(add_arduino_library_example _target_name _library_target_name _library_name
        _board_id _example_name)

    if (NOT TARGET ${_library_target_name})
        message(SEND_ERROR "Library target doesn't exist - It must be created first!")
    endif ()

    find_arduino_library_example_sources("${ARDUINO_SDK_LIBRARIES_PATH}/${_library_name}"
            ${_example_name} example_sketches ${ARGN})
    get_sources_from_sketches("${example_sketches}" example_sources)
    add_arduino_executable(${_target_name} ${_board_id} ${example_sources})
    link_arduino_library(${_target_name} ${_library_target_name} ${_board_id})

endfunction()