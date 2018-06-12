function(setup_remaining_platform_flags)

    set(ARDUINO_CMAKE_AVRDUDE_FLAGS ${tools_avrdude_upload_params_verbose})

    # Set AR flags based on the platform file
    if (compiler_ar_flags)
        set(CMAKE_ASM_ARCHIVE_CREATE
                "<CMAKE_AR> ${compiler_ar_flags} <TARGET> <LINK_FLAGS> <OBJECTS>"
                CACHE STRING "" FORCE)
        set(CMAKE_C_ARCHIVE_CREATE
                "<CMAKE_AR> ${compiler_ar_flags} <TARGET> <LINK_FLAGS> <OBJECTS>"
                CACHE STRING "" FORCE)
        set(CMAKE_CXX_ARCHIVE_CREATE
                "<CMAKE_AR> ${compiler_ar_flags} <TARGET> <LINK_FLAGS> <OBJECTS>"
                CACHE STRING "" FORCE)
    endif ()

endfunction()
