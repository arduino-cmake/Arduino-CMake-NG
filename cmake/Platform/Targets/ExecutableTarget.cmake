function(add_arduino_executable a_target_name _board_id _src_files)

    add_executable(${_target_name} "${_src_files}")

    # Create EEP object file from build's ELF object file
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
            COMMAND ${CMAKE_OBJCOPY}
            ARGS ${ARDUINO_CMAKE_OBJCOPY_EEP_FLAGS}
            ${TARGET_PATH}.elf
            ${TARGET_PATH}.eep
            COMMENT "Generating EEP image"
            VERBATIM)

    # Convert firmware image to ASCII HEX format
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
            COMMAND ${CMAKE_OBJCOPY}
            ARGS ${ARDUINO_CMAKE_OBJCOPY_HEX_FLAGS}
            ${TARGET_PATH}.elf
            ${TARGET_PATH}.hex
            COMMENT "Generating HEX image"
            VERBATIM)

endfunction()
