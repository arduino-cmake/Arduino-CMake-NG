#=============================================================================#
# Appends a suffic zero to the given version part if it's below than the given limit.
# Otherwise, the version part is returned as it is.
#
#       _version_part - Version to check and possibly append to.
#                 Must be a version part - Major, Minor or Patch.
#       _version_limit - Append limit. For a version greater than this number
#                       a zero will NOT be appended.
#       _return_var - Returned variable storing the normalized version.
#
#=============================================================================#
function(_append_suffix_zero _version_part _return_var)
    set(${_return_var} "${_version_part}0" PARENT_SCOPE)
endfunction()

#=============================================================================#
# _get_normalized_sdk_version
# [PRIVATE/INTERNAL]
#
# _get_normalized_sdk_version(_return_var)
#
#       _return_var - Returned variable storing the normalized version
#
# Normalizes SDK's version for a proper use of the '-DARDUINO' compile flag.
# Note that there are differences between normalized versions in specific SDK versions:
# e.g Version 1.6.5 will be normalized as 10605
#
#=============================================================================#
function(_get_normalized_sdk_version _return_var)

    # -DARDUINO format has changed since 1.6.0 by appending zeros when required
    _append_suffix_zero(${ARDUINO_CMAKE_SDK_VERSION_MAJOR} major_version)
    _append_suffix_zero(${ARDUINO_CMAKE_SDK_VERSION_MINOR} minor_version)
    set(normalized_version "${major_version}${minor_version}${ARDUINO_CMAKE_SDK_VERSION_PATCH}")

    set(${_return_var} "${normalized_version}" PARENT_SCOPE)

endfunction()

#=============================================================================#
# Detects the Arduino SDK Version based on the dedicated version 1file.
# The following variables will be generated:
#
#    ${ARDUINO_CMAKE_SDK_VERSION}         -> the full version (major.minor.patch)
#    ${ARDUINO_CMAKE_SDK_VERSION}_MAJOR   -> the major version
#    ${ARDUINO_CMAKE_SDK_VERSION}_MINOR   -> the minor version
#    ${ARDUINO_CMAKE_SDK_VERSION}_PATCH   -> the patch version
#
#=============================================================================#
function(detect_sdk_version)

    find_file(ARDUINO_CMAKE_VERSION_FILE_PATH
            NAMES version.txt
            PATHS "${ARDUINO_SDK_PATH}"
            PATH_SUFFIXES lib
            DOC "Path to Arduino's version file"
            NO_CMAKE_FIND_ROOT_PATH)

    if (NOT ARDUINO_CMAKE_VERSION_FILE_PATH)
        message(FATAL_ERROR "Couldn't find SDK's version file, aborting.")
    endif ()

    file(READ ${ARDUINO_CMAKE_VERSION_FILE_PATH} raw_version)

    if ("${raw_version}" STREQUAL "")
        message(FATAL_ERROR "Version file is found but its empty")
    endif ()

    string(REPLACE "." ";" split_version ${raw_version})
    list(GET split_version 0 split_version_major)
    list(GET split_version 1 split_version_minor)
    list(GET split_version 2 split_version_patch)

    set(ARDUINO_CMAKE_SDK_VERSION "${raw_version}" CACHE STRING "Arduino SDK Version")
    set(ARDUINO_CMAKE_SDK_VERSION_MAJOR ${split_version_major} CACHE STRING
            "Arduino SDK Major Version")
    set(ARDUINO_CMAKE_SDK_VERSION_MINOR ${split_version_minor} CACHE STRING
            "Arduino SDK Minor Version")
    set(ARDUINO_CMAKE_SDK_VERSION_PATCH ${split_version_patch} CACHE STRING
            "Arduino SDK Patch Version")

    if (ARDUINO_CMAKE_SDK_VERSION VERSION_LESS 1.6.0)
        message(FATAL_ERROR "Unsupported Arduino SDK (requires version 1.6 or higher)")
    endif ()

    _get_normalized_sdk_version(normalized_sdk_version)
    set(runtime_ide_version "${normalized_sdk_version}" CACHE STRING "")

    message(STATUS "Arduino SDK version ${ARDUINO_CMAKE_SDK_VERSION}: ${ARDUINO_SDK_PATH}")

endfunction()
