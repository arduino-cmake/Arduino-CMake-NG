function(arduino_cmake_project _project_name)

    project(${_project_name})

    set(ARDUINO_CMAKE_PROJECT_NAME ${_project_name} CACHE STRING "Current project name")

    setup_project_board(${ARGN})

endfunction()
