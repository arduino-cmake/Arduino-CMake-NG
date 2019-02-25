#=============================================================================#
# Uploads the given target to te connected Arduino board using the given board ID and port.
#       _target_name - Name of the target (Executable) to upload.
#       _port - Serial port on the host system used to upload/flash the connected Arduino board.
#=============================================================================#
function(set_target_upload_port _target_name _port)

    if (NOT TARGET ${_target_name})
        message(FATAL_ERROR "Can't create upload target for an invalid target ${_target_name}")
    else ()
        get_target_property(target_type ${_target_name} TYPE)
        if (NOT ${target_type} STREQUAL "EXECUTABLE") # Target is not executable
            message(SEND_ERROR "Upload target ${_target_name} must be an executable target")
        endif ()
    endif ()

    set_upload_target_flags(${_target_name} ${_port} upload_args)

    add_custom_target(${_target_name}_flash
            COMMAND ${ARDUINO_CMAKE_AVRDUDE_PROGRAM} ${upload_args}
            COMMENT "Uploading ${_target_name} target")

    add_dependencies(${_target_name}_flash ${_target_name})

endfunction()
