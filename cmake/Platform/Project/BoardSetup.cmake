function(setup_project_board _project_name)

    cmake_parse_arguments(parsed_args "" "BOARD_NAME;BOARD_CPU" "" ${ARGV})

    if (NOT parsed_args_BOARD_NAME)
        message(FATAL_ERROR "Expected board name in setup function")
    else ()

        get_board_id(board_id ${parsed_args_BOARD_NAME} ${parsed_args_BOARD_CPU})

        set(PROJECT_${_project_name}_BOARD ${board_id} CACHE STRING "Project-Global board ID")

    endif ()

endfunction()
