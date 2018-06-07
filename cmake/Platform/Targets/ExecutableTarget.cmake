function(add_arduino_executable _target_name _board_id _src_files)

    add_executable(${_target_name} "${_src_files}")

    # Include platform's core and variant directories
    target_include_directories(${_target_name} PUBLIC
            "${ARDUINO_CMAKE_CORE_${ARDUINO_CMAKE_PLATFORM_CORE}_PATH}")
    target_include_directories(${_target_name} PUBLIC
            "${ARDUINO_CMAKE_VARIANT_${ARDUINO_CMAKE_PLATFORM_VARIANT}_PATH}")

    # Add compiler and linker flags
    set_executable_target_flags(${_target_name} ${_board_id})

    # Modify executable's suffix to be '.elf'
    set_target_properties(${_target_name} PROPERTIES SUFFIX ".elf")

    # Create EEP object file from build's ELF object file
    add_custom_command(TARGET ${_target_name} POST_BUILD
            COMMAND ${CMAKE_OBJCOPY}
            ARGS ${compiler_objcopy_eep_flags}
            ${CMAKE_CURRENT_BINARY_DIR}/${_target_name}.elf
            ${CMAKE_CURRENT_BINARY_DIR}/${_target_name}.eep
            COMMENT "Generating EEP image"
            VERBATIM)

    # Convert firmware image to ASCII HEX format
    add_custom_command(TARGET ${_target_name} POST_BUILD
            COMMAND ${CMAKE_OBJCOPY}
            ARGS ${compiler_elf2hex_flags}
            ${CMAKE_CURRENT_BINARY_DIR}/${_target_name}.elf
            ${CMAKE_CURRENT_BINARY_DIR}/${_target_name}.hex
            COMMENT "Generating HEX image"
            VERBATIM)

endfunction()
