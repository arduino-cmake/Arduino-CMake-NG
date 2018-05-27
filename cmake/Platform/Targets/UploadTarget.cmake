function(upload_arduino_target _target_name _board_id)

    if (NOT ${_target_name})
        message(FATAL_ERROR "Can't create upload target for an invalid target ${_target_name}")
    endif ()

    add_custom_command(${BOOTLOADER_TARGET}
            ${ARDUINO_CMAKE_AVRDUDE_PROGRAM}
            ${AVRDUDE_ARGS}
            WORKING_DIRECTORY ${ARDUINO_CMAKE_BOOTLOADERS_PATH}/${BOOTLOADER_PATH}
            DEPENDS ${_target_name})

endfunction()