function(arduino_cmake_project _project_name)

    # Store the project's name in parent scope as if it were defined by the CMakeLists.txt file
    # that called this function. It helps ensure each "sub-project" can actually exists separately from the others,
    # as is the case with the examples of the framework.
    # This is done because CMake's `project()` function doesn't maintain scope properly,
    # thus a custom one is needed.
    set(ARDUINO_CMAKE_PROJECT_NAME ${_project_name} PARENT_SCOPE)

    setup_project_board(${_project_name} ${ARGN})

    setup_project_core_lib(${_project_name})

    set(ARDUINO_CMAKE_FUNCTION_DEFINITION_REGEX_PATTERN
            "^([A-Za-z0-9_][ \t\r\n]*)+\\(.*\\)$" PARENT_SCOPE)
    set(ARDUINO_CMAKE_FUNCTION_DECLARATION_REGEX_PATTERN
            "^([A-Za-z0-9_])+.+([A-Za-z0-9_])+[ \t\r\n]*\\((.*)\\);$" PARENT_SCOPE)
    set(ARDUINO_CMAKE_FUNCTION_NAME_REGEX_PATTERN "(([A-Za-z0-9_])+)[ \t\r\n]*\\(.*\\)" PARENT_SCOPE)
    set(ARDUINO_CMAKE_FUNCTION_ARGS_REGEX_PATTERN "\\((.*)\\)" PARENT_SCOPE)
    set(ARDUINO_CMAKE_FUNCTION_SINGLE_ARG_REGEX_PATTERN "([A-Za-z0-9_]+)[^,]*" PARENT_SCOPE)
    set(ARDUINO_CMAKE_FUNCTION_ARG_TYPE_REGEX_PATTERN "[A-Za-z0-9_]+.*[ \t\r\n]+" PARENT_SCOPE)

endfunction()
