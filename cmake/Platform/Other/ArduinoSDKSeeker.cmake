#=============================================================================#
# Attempts to find the Arduino SDK in the host system, searching at known locations.
# For each host OS the locations are different, however, eventually they all search for the
# 'lib/version.txt' file, which is located directly under the SDK directory under ALL OSs.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Path to the found Arudino SDK.
#=============================================================================#
function(find_arduino_sdk _return_var)

    set(path_suffixes "")

    if (${CMAKE_HOST_UNIX})
        if (${CMAKE_HOST_APPLE})
            set(platform_search_paths ~/Applications /Applications /Developer/Applications
                    /sw /opt/local)
            set(path_suffixes Arduino.app/Contents/Java/ Arduino.app/Contents/Resources/Java/)
        else () # Probably Linux
            file(GLOB platform_search_paths /usr/share/arduino* /opt/local/arduino* /opt/arduino*
                    /usr/local/share/arduino*)
        endif ()
    elseif (${CMAKE_HOST_WIN32})
        set(platform_search_paths "C:/Program Files (x86)/Arduino" "C:/Program Files/Arduino")
    endif ()

    find_path(ARDUINO_SDK_PATH
            NAMES lib/version.txt
            PATH_SUFFIXES ${path_suffixes}
            HINTS ${platform_search_paths}
            NO_DEFAULT_PATH
            NO_CMAKE_FIND_ROOT_PATH)

    if (${ARDUINO_SDK_PATH} MATCHES "NOTFOUND")
        string(CONCAT error_message
                "Couldn't find Arduino SDK path - Is it in a non-standard location?" "\n"
                "If so, please set the ARDUINO_SDK_PATH CMake-Variable")
        message(FATAL_ERROR ${error_message})
    else ()
        set(${_return_var} "${ARDUINO_SDK_PATH}" PARENT_SCOPE)
    endif ()

endfunction()

