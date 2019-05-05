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

#=============================================================================#
# Attempts to find the Arduino SDK's bin folder in the host system, searching at known locations.
# Most installs will have it at SDK/hardware/tools/avr/bin but if nothing is there, it will 
# attempt to find a folder in PATH containing avr-gcc, hoping that everything else will be there too
# This is because a bunch of linux distros' package managers install the binaries into /usr/bin
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Path to the folder containing Arduino compiler binaries
#=============================================================================#
function(find_arduino_sdk_bin _return_var)

    if (DEFINED ENV{ARDUINO_SDK_BIN_PATH})
        string(REPLACE "\\" "/" unix_style_sdk_bin_path $ENV{ARDUINO_SDK_BIN_PATH})
        set(${_return_var} "${unix_style_sdk_bin_path}" PARENT_SCOPE)
    elseif (IS_DIRECTORY "${ARDUINO_SDK_PATH}/hardware/tools/avr/bin")
        set(${_return_var} "${ARDUINO_SDK_PATH}/hardware/tools/avr/bin" PARENT_SCOPE)
    else ()
        # Some systems like the Arch Linux arduino package install binaries to /usr/bin
        # But gcc can be found first in ccache folder so let's search ar instead
        find_program(avr_gcc_ar_location avr-gcc-ar)
        if ("${avr_gcc_ar_location}" MATCHES "NOTFOUND")
            string(CONCAT error_message
                    "Couldn't find Arduino bin path - Is it in a non-standard location?" "\n"
                    "If so, please set the ARDUINO_SDK_BIN_PATH CMake-Variable")
            message(FATAL_ERROR ${error_message})
        else ()
            get_filename_component(avr_gcc_ar_parent ${avr_gcc_ar_location} DIRECTORY)
            set(${_return_var} "${avr_gcc_ar_parent}" PARENT_SCOPE)
        endif ()
    endif ()

endfunction()

#=============================================================================#
# Attempts to find the Arduino SDK's root folder in the host system, searching at known locations.
# Most installs will have it at SDK/hardware/tools/avr/ but if nothing is there, it will 
# attempt to find a folder containing etc/avrdude.conf, since a bunch of linux distros
# put this into /etc rather than a subdirectory of the arduino SDK
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Path to the directory containing etc/avrdude.conf
#=============================================================================#
function(find_arduino_sdk_root _return_var)

    if (DEFINED ENV{ARDUINO_SDK_ROOT_PATH})
        string(REPLACE "\\" "/" unix_style_sdk_root_path $ENV{ARDUINO_SDK_ROOT_PATH})
        set(${_return_var} "${unix_style_sdk_root_path}" PARENT_SCOPE)
    elseif (EXISTS "${ARDUINO_SDK_PATH}/hardware/tools/avr/etc/avrdude.conf")
        set(${_return_var} "${ARDUINO_SDK_PATH}/hardware/tools/avr" PARENT_SCOPE)
    elseif (EXISTS "/etc/avrdude.conf" OR EXISTS "/etc/avrdude/avrdude.conf")
        set(${_return_var} "/" PARENT_SCOPE)
    else ()
        string(CONCAT error_message
                "Couldn't find Arduino root path - Is it in a non-standard location?" "\n"
                "If so, please set the ARDUINO_SDK_ROOT_PATH CMake-Variable")
        message(FATAL_ERROR ${error_message})
    endif ()

endfunction()
