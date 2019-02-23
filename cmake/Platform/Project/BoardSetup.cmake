function(setup_project_board)

    cmake_parse_arguments(parsed_args "" "BOARD_NAME;BOARD_CPU" "" ${ARGV})

    if (NOT parsed_args_BOARD_NAME)
        message(FATAL_ERROR "Expected board name in setup function")
    else ()

        get_board_id(board_id ${parsed_args_BOARD_NAME} ${parsed_args_BOARD_CPU})

        set(ARDUINO_CMAKE_PROJECT_BOARD ${board_id} CACHE STRING "Project-Wide board ID")

    endif ()

endfunction()
