function(add_arduino_core_lib _target_name _board_id)

    string(REPLACE "." "_" board_id "${_board_id}")
    set(core_lib_target "${board_id}_core_lib")
    string(TOUPPER "${core_lib_target}" core_lib_target)

    if (TARGET ${core_lib_target}) # Core-lib target already created for the given board
        if (TARGET ${_target_name}) # Executable/Firmware target also exists
            # Link Core-Lib to executable
            target_link_libraries(${_target_name} ${core_lib_target})
        endif ()
        return()
    else () # Core-Lib target needs to be created
        # Get board's core
        get_board_property("${_board_id}" "build.core" board_core)
        string(TOLOWER ${board_core} board_core)
        list(FIND ARDUINO_CMAKE_PLATFORM_CORES "${board_core}" board_core_index)

        # Get board's variant
        get_board_property("${_board_id}" "build.variant" board_variant)
        string(TOLOWER ${board_variant} board_variant)
        list(FIND ARDUINO_CMAKE_PLATFORM_VARIANTS "${board_variant}" board_variant_index)

        if (${board_core_index} LESS 0)
            message(FATAL_ERROR
                    "Unknown board core \"${board_core}\" for the ${_board_id} board")
        elseif (${board_variant_index} LESS 0)
            message(FATAL_ERROR
                    "Unknown board variant \"${board_variant}\" for the ${_board_id} board")
        else ()
            find_source_files("${ARDUINO_CMAKE_CORE_${board_core}_PATH}" core_sources)

            add_library(${core_lib_target} STATIC "${core_sources}")
            # Include platform's core and variant directories
            target_include_directories(${core_lib_target} PUBLIC
                    "${ARDUINO_CMAKE_CORE_${board_core}_PATH}")
            target_include_directories(${core_lib_target} PUBLIC
                    "${ARDUINO_CMAKE_VARIANT_${board_variant}_PATH}")
            set_compiler_target_flags(${core_lib_target} "${_board_id}")

            # Link Core-Lib to executable target
            if (TARGET ${_target_name})
                target_link_libraries(${_target_name} ${core_lib_target})
            endif ()
        endif ()
    endif ()

endfunction()
