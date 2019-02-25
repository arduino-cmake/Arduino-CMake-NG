function(setup_project_core_lib _project_name)

    # Guard against redefiniton of the Core Lib target
    if (NOT TARGET ${${PROJECT_${_project_name}_BOARD}_CORELIB_TARGET})

        add_arduino_core_lib(${PROJECT_${_project_name}_BOARD} target_name)

        # Define a global way to access Core Lib's target name
        set(${PROJECT_${_project_name}_BOARD}_CORELIB_TARGET ${target_name}
                CACHE STRING "Project-Global CoreLib target name")

    endif ()

endfunction()
