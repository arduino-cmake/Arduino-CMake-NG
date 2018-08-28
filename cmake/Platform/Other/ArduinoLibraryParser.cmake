#=============================================================================#
# Retrieves all registered platform library names from the given list of names,
# which usually resolves to names of headers included by a source file.
#       _names - List of names that possibly contain a registered platform library's name.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - List of retrieved platform libraries names.
#=============================================================================#
function(get_platform_libraries_from_names _names _return_var)

    foreach (name ${_names})
        string(TOLOWER "${name}" name_lower)
        if ("${name_lower}" IN_LIST ARDUINO_CMAKE_PLATFORM_LIBRARIES)
            list(APPEND platform_libs "${name}")
        endif ()
    endforeach ()

    set(${_return_var} ${platform_libs} PARENT_SCOPE)

endfunction()
