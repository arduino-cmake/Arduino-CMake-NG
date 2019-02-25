#=============================================================================#
# Sets compiler and linker flags on the given library target.
# Changes are kept even outside the scope of the function since they apply on a target.
#       _library_target - Name of the library target.
#=============================================================================#
function(set_library_flags _library_target)

    parse_scope_argument(scope "${ARGN}"
            DEFAULT_SCOPE PUBLIC)

    set_target_compile_flags(${_library_target} ${PROJECT_${ARDUINO_CMAKE_PROJECT_NAME}_BOARD} ${scope})

    # Set linker flags
    set_target_linker_flags(${_library_target} ${PROJECT_${ARDUINO_CMAKE_PROJECT_NAME}_BOARD})

endfunction()
