function(add_arduino_executable _target_name _board_id _src_files)

    add_executable(${_target_name} "${_src_files}")
    target_include_directories(${_target_name} PUBLIC
            "${ARDUINO_CMAKE_CORE_${ARDUINO_CMAKE_PLATFORM_CORE}_PATH}")
    target_include_directories(${_target_name} PUBLIC
            "${ARDUINO_CMAKE_VARIANT_${ARDUINO_CMAKE_PLATFORM_VARIANT}_PATH}")
    set_target_properties(${_target_name} PROPERTIES SUFFIX ".elf")

    # Create EEP object file from build's ELF object file
    add_custom_command(TARGET ${_target_name} POST_BUILD
            COMMAND ${CMAKE_OBJCOPY}
            ARGS ${ARDUINO_CMAKE_OBJCOPY_EEP_FLAGS}
            ${CMAKE_CURRENT_BINARY_DIR}/${_target_name}.elf
            ${CMAKE_CURRENT_BINARY_DIR}/${_target_name}.eep
            COMMENT "Generating EEP image"
            VERBATIM)

    # Convert firmware image to ASCII HEX format
    add_custom_command(TARGET ${_target_name} POST_BUILD
            COMMAND ${CMAKE_OBJCOPY}
            ARGS ${ARDUINO_CMAKE_OBJCOPY_HEX_FLAGS}
            ${CMAKE_CURRENT_BINARY_DIR}/${_target_name}.elf
            ${CMAKE_CURRENT_BINARY_DIR}/${_target_name}.hex
            COMMENT "Generating HEX image"
            VERBATIM)

endfunction()
