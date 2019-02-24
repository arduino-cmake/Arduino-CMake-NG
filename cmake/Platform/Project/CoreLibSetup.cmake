function(setup_project_core_lib)

    # Guard against redefiniton of the Core Lib target
    if (NOT TARGET ${${PROJECT_${ARDUINO_CMAKE_PROJECT_NAME}_BOARD}_CORELIB_TARGET})

        add_arduino_core_lib(${PROJECT_${ARDUINO_CMAKE_PROJECT_NAME}_BOARD} target_name)

        # Define a global way to access Core Lib's target name
        set(${PROJECT_${ARDUINO_CMAKE_PROJECT_NAME}_BOARD}_CORELIB_TARGET ${target_name}
                CACHE STRING "Project-Global CoreLib target name")

    endif ()

endfunction()
