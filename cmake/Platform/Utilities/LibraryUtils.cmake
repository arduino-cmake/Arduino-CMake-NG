#=============================================================================#
# Gets the full path to a library's properties file based on the given library root directory.
# If the root ditectory doesn't exist, CMake generates an error and stops.
# If the properties file doesn't exist under the given root directory,
# CMake generates a warning and returns an empty string.
#       _library_root_directory - Path to library's root directory. Can be relative.
#       _return_var - Name of a CMake variable that will hold the extraction result.
#       Returns - Full path to library's properties file if found, otherwise nothing.
#=============================================================================#
function(get_library_properties_file _library_root_directory _return_var)

    get_filename_component(absolute_lib_root_dir ${_library_root_directory} ABSOLUTE)

    if (NOT EXISTS ${absolute_lib_root_dir})
        message(SEND_ERROR "Can't get library's properties file - Root directory doesn't exist.\n"
                "Root directory: ${absolute_lib_root_dir}")
    endif ()

    set(lib_props_file ${absolute_lib_root_dir}/${ARDUINO_CMAKE_LIBRARY_PROPERTIES_FILE_NAME})

    if (NOT EXISTS ${lib_props_file})
        message(STATUS "Library's properties file doesn't exist under the given root directory.\n\t"
                "Root directory: ${absolute_lib_root_dir}")
        return()
    endif ()

    set(${_return_var} ${lib_props_file} PARENT_SCOPE)

endfunction()
