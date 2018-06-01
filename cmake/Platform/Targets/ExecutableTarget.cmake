function(add_arduino_executable _target_name _board_id _src_files)

    add_executable(${_target_name} "${_src_files}")
    #[[target_include_directories(${_target_name}
            "${ARDUINO_CMAKE_CORE_${ARDUINO_CMAKE_PLATFORM_DEFAULT_CORE}_PATH}")]]

    # Create EEP object file from build's ELF object file
    add_custom_command(TARGET ${_target_name} POST_BUILD
            COMMAND ${CMAKE_OBJCOPY}
            ARGS ${ARDUINO_CMAKE_OBJCOPY_EEP_FLAGS}
            ${TARGET_PATH}.elf
            ${TARGET_PATH}.eep
            COMMENT "Generating EEP image"
            VERBATIM)

    # Convert firmware image to ASCII HEX format
    add_custom_command(TARGET ${_target_name} POST_BUILD
            COMMAND ${CMAKE_OBJCOPY}
            ARGS ${ARDUINO_CMAKE_OBJCOPY_HEX_FLAGS}
            ${TARGET_PATH}.elf
            ${TARGET_PATH}.hex
            COMMENT "Generating HEX image"
            VERBATIM)

endfunction()
