#=============================================================================#
# Sets compiler flags on the given target using the given board ID, compiler language and scope.
#       _target_name - Name of the target (Executable or Library) to set flags on.
#       _board_id - Target's bounded board ID.
#       _language - Language for which flags are set (such as C/C++).
#       _scope - Flags' scope relative to outer targets (targets using the given target).
#=============================================================================#
function(_set_target_language_flags _target_name _board_id _language _scope)

    parse_compiler_recipe_flags(${_board_id} compiler_recipe_flags
            LANGUAGE "${_language}")

    target_compile_options(${_target_name} ${_scope}
            $<$<COMPILE_LANGUAGE:${_language}>:${compiler_recipe_flags}>)

endfunction()

#=============================================================================#
# Sets compiler flags on the given target, according also to the given board ID.
#       _target_name - Name of the target (Executable or Library) to set flags on.
#       _board_id - Target's bounded board ID.
#=============================================================================#
function(set_compiler_target_flags _target_name _board_id)

    cmake_parse_arguments(parsed_args "" "LANGUAGE" "" ${ARGN})
    parse_scope_argument(scope "${ARGN}"
            DEFAULT_SCOPE PUBLIC)

    if (parsed_args_LANGUAGE)
        _set_target_language_flags(${_target_name} ${_board_id} ${parsed_args_LANGUAGE} ${scope})

    else () # No specific language requested - Use all

        get_cmake_compliant_language_name(asm lang)
        _set_target_language_flags(${_target_name} ${_board_id} ${lang} ${scope})

        get_cmake_compliant_language_name(c lang)
        _set_target_language_flags(${_target_name} ${_board_id} ${lang} ${scope})

        get_cmake_compliant_language_name(cpp lang)
        _set_target_language_flags(${_target_name} ${_board_id} ${lang} ${scope})

    endif ()

endfunction()

#=============================================================================#
# Sets linker flags on the given target, according also to the given board ID.
#       _target_name - Name of the target (Executable or Library) to set flags on.
#       _board_id - Target's bounded board ID.
#=============================================================================#
function(set_linker_flags _target_name _board_id)

    parse_linker_recpie_pattern("${_board_id}" linker_recipe_flags)

    string(REPLACE ";" " " cmake_compliant_linker_flags "${linker_recipe_flags}")

    set(CMAKE_EXE_LINKER_FLAGS "${cmake_compliant_linker_flags}" CACHE STRING "" FORCE)

endfunction()

#=============================================================================#
# Sets compiler and linker flags on the given Executable target,
# according also to the given board ID.
#       _target_name - Name of the target (Executable) to set flags on.
#       _board_id - Target's bounded board ID.
#=============================================================================#
function(set_executable_target_flags _target_name _board_id)

    set_compiler_target_flags(${_target_name} "${_board_id}")
    set_linker_flags(${_target_name} "${_board_id}")

    target_link_libraries(${_target_name} PUBLIC m) # Add math library

    # Modify executable's suffix to be '.elf'
    set_target_properties("${_target_name}" PROPERTIES SUFFIX ".elf")

endfunction()

#=============================================================================#
# Sets upload/flash flags on the given target, according also to the given board ID.
#       _target_name - Name of the target (Executable) to set flags on.
#       _board_id - Target's bounded board ID.
#=============================================================================#
function(set_upload_target_flags _target_name _board_id _upload_port _return_var)

    set(upload_flags "")

    # Parse and append recipe flags
    parse_upload_recipe_pattern("${_board_id}" "${_upload_port}" upload_recipe_flags)
    list(APPEND upload_flags "${upload_recipe_flags}")

    set(target_binary_base_path "${CMAKE_CURRENT_BINARY_DIR}/${_target_name}")

    list(APPEND upload_flags "-Uflash:w:\"${target_binary_base_path}.hex\":i")
    list(APPEND upload_flags "-Ueeprom:w:\"${target_binary_base_path}.eep\":i")

    set(${_return_var} "${upload_flags}" PARENT_SCOPE)

endfunction()

#=============================================================================#
# Adds a compiler definition (#define) for the given architecture to the target.
# The affecting scope of the definition is controlled by the _scope argument.
#       _target - Name of the target (Executable) to set flags on.
#       _scope - PUBLIC|INTERFACE|PRIVATE. Affects outer scope - How other targets see it.
#       _architecture - Architecture to define, e.g. 'avr'
#=============================================================================#
function(set_target_architecture_definition _target _scope _architecture)

    string(TOUPPER ${_architecture} upper_arch)
    set(arch_definition "ARDUINO_ARCH_${upper_arch}")

    target_compile_definitions(${_target} ${_scope} ${arch_definition})

endfunction()
