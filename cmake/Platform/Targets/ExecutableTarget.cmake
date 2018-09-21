#=============================================================================#
# Adds/Creates an Arduino-Executable target with the given name,
# using the given board ID and source files.
#       _target_name - Name of the target (Executable) to create.
#       _board_id - ID of the board to bind to the target (Each target can have a single board).
#       [Sources] - List of source files (Could also be headers for code-inspection in some IDEs)
#                   to create the executable from, similar to CMake's built-in add_executable.
#=============================================================================#
function(add_arduino_executable _target_name _board_id)

    list(APPEND sources "${ARGN}") # Treat all remaining arguments as sources

    add_executable(${_target_name} "${sources}")
    # Always add board's core lib
    add_arduino_core_lib(${_target_name} "${_board_id}")
    # Add compiler and linker flags
    set_executable_target_flags(${_target_name} "${_board_id}")

    set(target_path "${CMAKE_CURRENT_BINARY_DIR}/${_target_name}")

    # Create EEP object file from build's ELF object file
    add_custom_command(TARGET ${_target_name} POST_BUILD
            COMMAND ${CMAKE_OBJCOPY}
            ARGS ${compiler_objcopy_eep_flags}
            ${target_path}.elf
            ${target_path}.eep
            COMMENT "Generating EEP image"
            VERBATIM)

    # Convert firmware image to ASCII HEX format
    add_custom_command(TARGET ${_target_name} POST_BUILD
            COMMAND ${CMAKE_OBJCOPY}
            ARGS ${compiler_elf2hex_flags}
            ${target_path}.elf
            ${target_path}.hex
            COMMENT "Generating HEX image"
            VERBATIM)

    # Required for avr-size
    get_board_property("${_board_id}" build.mcu board_mcu)
    set(avr_size_script
            "${ARDUINO_CMAKE_TOOLCHAIN_DIR}/Platform/Other/FirmwareSizeCalculator.cmake")

    add_custom_command(TARGET ${_target_name} POST_BUILD
            COMMAND ${CMAKE_COMMAND}
            ARGS -DFIRMWARE_IMAGE=${target_path}.elf -DEEPROM_IMAGE=${target_path}.eep
            -DMCU=${board_mcu} -DAVRSIZE_PROGRAM=${ARDUINO_CMAKE_AVRSIZE_PROGRAM}
            -P "${avr_size_script}"
            COMMENT "Calculating ${_target_name} size"
            VERBATIM)

endfunction()
