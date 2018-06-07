function(_setup_bootloader_arguments _board_id _port _return_var)

    set(avrdude_flags "")

    # Parse and append recipe flags
    parse_upload_recipe_pattern(${_board_id} ${_port} upload_recipe_flags)
    list(APPEND avrdude_flags "${upload_recipe_flags}")

    message("Bootloader args: ${avrdude_flags}")

    set(${_return_var} ${avrdude_flags} PARENT_SCOPE)

endfunction()

function(upload_arduino_target _target_name _board_id _port)

    if ("${_target_name}" STREQUAL "")
        message(FATAL_ERROR "Can't create upload target for an invalid target ${_target_name}")
    endif ()

    _setup_bootloader_arguments("${_board_id}" ${_port} upload_args)
    set(target_binary_base_path "${CMAKE_CURRENT_BINARY_DIR}/${_target_name}")
    list(APPEND upload_args "-Uflash:w:\"${target_binary_base_path}.hex\":i")
    list(APPEND upload_args "-Ueeprom:w:\"${target_binary_base_path}.eep\":i")

    add_custom_command(TARGET ${_target_name} POST_BUILD
            COMMAND ${ARDUINO_CMAKE_AVRDUDE_PROGRAM}
            ARGS ${upload_args}
            COMMENT "Uploading ${_target_name} target"
            DEPENDS ${_target_name})

endfunction()