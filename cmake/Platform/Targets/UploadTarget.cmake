function(_setup_bootloader_arguments _board_id _port _return_var)

    set(avrdude_flags ${ARDUINO_CMAKE_AVRDUDE_FLAGS})

    message("BID: ${_board_id}")
    get_board_property(${_board_id} build.mcu board_mcu)
    if (NOT "${board_mcu}" STREQUAL "") # MCU is found
        list(APPEND avrdude_flags "-p${board_mcu}")
    endif ()

    get_board_property(${_board_id} upload.protocol board_upload_protocol)
    if (NOT "${board_upload_protocol}" STREQUAL "") # Upload protocol is found
        if ("${board_upload_protocol}" STREQUAL "stk500")
            set(board_upload_protocol "stk500v1")
        endif ()
        list(APPEND avrdude_flags "-c${board_upload_protocol}")
    endif ()

    get_board_property(${_board_id} upload.speed board_upload_speed)
    if (NOT "${board_upload_speed}" STREQUAL "") # Speed is found
        list(APPEND avrdude_flags "-b${board_upload_speed}")
    endif ()

    list(APPEND avrdude_flags "-P${_port}" "-D") # Upload port, don't erase
    list(APPEND avrdude_flags "-C${ARDUINO_CMAKE_AVRDUDE_CONFIG_PATH}") # Avrdude config file

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