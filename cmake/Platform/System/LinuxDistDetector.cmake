function(detect_host_linux_distribution)

    if (NOT ${CMAKE_HOST_UNIX})
        message(AUTHOR_WARNING "Linux distribution detection called on non-Unix platform")
    elseif (${CMAKE_HOST_APPLE})
        message(AUTHOR_WARNING "Linux distribution detection called on Apple platform")
    else () # Linux host
        find_program(lsb_release_exec lsb_release)

        if ("lsb_release_exec-NOTFOUND" STREQUAL "${lsb_release_exec}")
            message(WARNING "Linux distribution couldn't be detected - Please install 'lsb_release'.")
        endif()

        execute_process(COMMAND ${lsb_release_exec} -is
                OUTPUT_VARIABLE lsb_release_id_short
                OUTPUT_STRIP_TRAILING_WHITESPACE)
        string(TOUPPER dist ${lsb_release_id_short})
        set(CMAKE_HOST_${dist} TRUE CACHE BOOL
                "Whether host system is ${lsb_release_id_short}" ADVANCED)
    endif ()

endfunction()
