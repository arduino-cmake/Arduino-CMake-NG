#=============================================================================#
# Checks whether the given core is valid by searching it in the list of known cores.
# The function doesn't return on failure but fails generation completely instead.
#=============================================================================#
function(_is_board_core_valid _board_core _board_id)

    list(FIND ARDUINO_CMAKE_PLATFORM_CORES "${board_core}" index)

    if (${index} LESS 0)
        message(FATAL_ERROR "Unknown board core \"${board_core}\" for the ${_board_id} board")
    endif ()

endfunction()

#=============================================================================#
# Checks whether the given variant is valid by searching it in the list of known variants.
# The function doesn't return on failure but fails generation completely instead.
#=============================================================================#
function(_is_board_variant_valid _board_variant _board_id)

    list(FIND ARDUINO_CMAKE_PLATFORM_VARIANTS "${board_variant}" index)

    if (${index} LESS 0)
        message(FATAL_ERROR "Unknown board variant \"${board_variant}\" for the ${_board_id} board")
    endif ()

endfunction()

#=============================================================================#
# Gets the core property of the given board, and returns it if it's a valid core.
#       _board_id - Board to get its' core represented by its' ID
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Retrieved board core, if valid. Otherwise, generation stops completely.
#=============================================================================#
function(_get_board_core _board_id _return_var)

    get_board_property(${_board_id} "build.core" board_core)
    string(TOLOWER ${board_core} board_core)
    _is_board_core_valid(${board_core} ${_board_id})

    set(${_return_var} ${board_core} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Gets the variant property of the given board, and returns it if it's a valid variant.
#       _board_id - Board to get its' variant represented by its' ID
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Retrieved board variant, if valid. Otherwise, generation stops completely.
#=============================================================================#
function(_get_board_variant _board_id _return_var)

    get_board_property(${_board_id} "build.variant" board_variant)
    string(TOLOWER ${board_variant} board_variant)
    _is_board_variant_valid(${board_variant} ${_board_id})

    set(${_return_var} ${board_variant} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Sets compiler and linker flags on the given Core-Lib target.
# Changes are kept even outside the scope of the function since they apply on a target.
#       _core_target_name - Name of the Core-Lib target.
#       _board_id - Board ID asociated with the target.
#=============================================================================#
function(_set_core_lib_flags _core_target_name _board_id)

    set_target_compile_flags(${_core_target_name} ${_board_id} PUBLIC)
    set_target_linker_flags(${_core_target_name} ${_board_id})

endfunction()

#=============================================================================#
# Adds/Creates a static library target for Arduino's core library (Core-Lib),
# required by every arduino target.
#       _board_id - Board to create the core library for.
#                   Note that each board has a unique version of the library.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Generated Core-lib's target name.
#=============================================================================#
function(add_arduino_core_lib _board_id _return_var)

    generate_core_lib_target_name(${_board_id} core_lib_target)

    _get_board_core(${_board_id} board_core) # Get board's core
    _get_board_variant(${_board_id} board_variant) # Get board's variant

    # Find sources in core directory and add the library target
    find_source_files("${ARDUINO_CMAKE_CORE_${board_core}_PATH}" core_sources)

    if (CMAKE_HOST_UNIX)
        if (CMAKE_HOST_UBUNTU OR CMAKE_HOST_DEBIAN)
            list(FILTER core_sources EXCLUDE REGEX "[Mm]ain\\.c.*")
        endif ()
    endif ()

    add_library(${core_lib_target} STATIC "${core_sources}")

    # Include platform's core and variant directories
    target_include_directories(${core_lib_target} PUBLIC "${ARDUINO_CMAKE_CORE_${board_core}_PATH}")
    target_include_directories(${core_lib_target} PUBLIC "${ARDUINO_CMAKE_VARIANT_${board_variant}_PATH}")

    _set_core_lib_flags(${core_lib_target} ${_board_id})

    set(${_return_var} ${core_lib_target} PARENT_SCOPE)

endfunction()
