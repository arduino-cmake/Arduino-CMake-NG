#=============================================================================#
# Uploads the given target to te connected Arduino board using the given board ID and port.
#       _target_name - Name of the target (Executable) to upload.
#       _board_id - Target's bounded board ID.
#       _port - Serial port on the host system used to upload/flash the connected Arduino board.
#=============================================================================#
function(upload_arduino_target _target_name _board_id _port)

    if ("${_target_name}" STREQUAL "")
        message(FATAL_ERROR "Can't create upload target for an invalid target ${_target_name}")
    endif ()

    set_upload_target_flags("${_target_name}" "${_board_id}" "${_port}" upload_args)

    add_custom_command(TARGET ${_target_name} POST_BUILD
            COMMAND ${ARDUINO_CMAKE_AVRDUDE_PROGRAM}
            ARGS ${upload_args}
            COMMENT "Uploading ${_target_name} target"
            DEPENDS ${_target_name})

endfunction()