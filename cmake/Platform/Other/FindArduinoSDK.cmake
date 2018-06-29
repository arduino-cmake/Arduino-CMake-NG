function(find_arduino_sdk _return_var)

    if (${CMAKE_HOST_UNIX})
        if (${CMAKE_HOST_APPLE})
            set(platform_search_paths ~/Applications /Applications /Developer/Applications
                    /sw /opt/local)
        else () # Probably Linux
            file(GLOB platform_search_paths /usr/share/arduino* /opt/local/arduino* /opt/arduino*
                    /usr/local/share/arduino*)
        endif ()
    elseif (${CMAKE_HOST_WIN32})
        set(platform_search_paths "C:/Program Files (x86)/Arduino" "C:/Program Files/Arduino")
    endif ()

    find_program(arduino_program_path
            NAMES arduino
            PATHS ${platform_search_paths}
            NO_DEFAULT_PATH
            NO_CMAKE_FIND_ROOT_PATH)
    get_filename_component(sdk_path "${arduino_program_path}" DIRECTORY)

    if (NOT sdk_path OR "${sdk_path}" MATCHES "NOTFOUND")
        string(CONCAT error_message
                "Couldn't find Arduino SDK path - Is it in a non-standard location?" "\n"
                "If so, please set the ARDUINO_SDK_PATH CMake-Variable")
        message(FATAL_ERROR ${error_message})
    else ()
        set(${_return_var} "${sdk_path}" PARENT_SCOPE)
    endif ()

endfunction()
