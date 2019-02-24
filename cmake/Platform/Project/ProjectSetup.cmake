function(arduino_cmake_project _project_name)

    # Define internal variable to store the project's name, twice:
    # 1. Define in parent scope as if it were defined by the CMakeLists.txt file that called this function
    # 2. Define as a standard local variable so that functions called below also can use this variable
    # It helps ensure each "sub-project" can actually exists separately from the others,
    # as is the case with the examples of the framework.
    # All of this is done because CMake's `project()` function doesn't maintain scope properly,
    # thus a custom one is needed.
    set(ARDUINO_CMAKE_PROJECT_NAME ${_project_name} PARENT_SCOPE)
    set(ARDUINO_CMAKE_PROJECT_NAME ${_project_name})

    setup_project_board(${ARGN})

    setup_project_core_lib()

endfunction()
