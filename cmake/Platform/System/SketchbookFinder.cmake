#=============================================================================#
# Gets the path of the user's Arduino IDE preferences file, usually located in a hidden directory
# under the home directory.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Filtered list of architectures.
#=============================================================================#
function(_get_user_preferences_file_path _return_var)

    set(preferences_file_name preferences.txt)

    if (${CMAKE_HOST_UNIX})
        if (${CMAKE_HOST_APPLE}) # Mac OS X
            set(dir_path "$ENV{HOME}/Library/Processing/${preferences_file_name}")
        else () # Linux
            set(dir_path "$ENV{HOME}/.processing/${preferences_file_name}")
        endif ()
    else () # Windows
        string(REPLACE "\\" "/" home_path $ENV{HOMEPATH})
        string(REPLACE "\\" "/" home_drive $ENV{HOMEDRIVE})
        string(CONCAT home_path ${home_drive} ${home_path})
        set(dir_path "${home_path}/AppData/Local/arduino15/${preferences_file_name}")
    endif ()

    set(${_return_var} ${dir_path} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Finds the location of Arduino IDE's Sketchbook directory, where all libraries and sketches
# are downloaded to.
#=============================================================================#
function(find_sketchbook_path)

    _get_user_preferences_file_path(arduino_ide_preferences_file)
    if (NOT EXISTS "${arduino_ide_preferences_file}")
        string(CONCAT error_message
                "Arduino IDE preferences file couldn't be found at "
                "${arduino_ide_preferences_file}.\n"
                "ARDUINO_CMAKE_SKETCHBOOK_PATH should be manually set to the real Sketchbook path")
        message(WARNING ${error_message})
        return()
    endif ()

    file(STRINGS "${arduino_ide_preferences_file}" arduino_ide_preferences)
    list(FILTER arduino_ide_preferences INCLUDE REGEX "sketchbook")
    _get_property_value(${arduino_ide_preferences} sketchbook_path)

    set(ARDUINO_CMAKE_SKETCHBOOK_PATH "${sketchbook_path}" CACHE PATH
            "Arduino IDE's Sketchbook Path")

endfunction()
