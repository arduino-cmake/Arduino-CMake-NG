#=============================================================================#
# Gets the library architecure if any, read from the given library properties file
# which includes this information.
#       _library_properties_file - Full path to a library's properties file.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - If library is architecure neutral, nothing is returned.
#                 If library doesn't support the current platform's architecture,
#                 "UNSUPPORTED" string is returned.
#                 Otherwise, the platform's architecture is returned.
#=============================================================================#
function(get_library_architecture _library_properties_file _return_var)

    file(STRINGS ${_library_properties_file} library_properties)

    list(FILTER library_properties INCLUDE REGEX "arch")
    _get_property_value("${library_properties}" arch_list)
    string(REPLACE "," ";" arch_list ${arch_list}) # Turn into a valid list

    if ("${arch_list}" MATCHES "\\*")
        return() # Any architecture is supported, return nothing
    else ()
        list(LENGTH arch_list num_of_supported_archs)
        if (${num_of_supported_archs} GREATER 1) # Number of architectures is supported
            list(FIND arch_list ${ARDUINO_CMAKE_PLATFORM_ARCHITECTURE} platform_arch_index)
            if (${platform_arch_index} LESS 0) # Our arch isn't supported
                set(__arch "UNSUPPORTED")
            else () # Our arch is indeed supported
                set(__arch ${arch_list})
            endif ()
        else ()
            list(GET arch_list 0 __arch)
            if (NOT "${__arch}" STREQUAL "${ARDUINO_CMAKE_PLATFORM_ARCHITECTURE}")
                set(__arch "UNSUPPORTED") # Our arch isn't supported
            endif ()
        endif ()
    endif ()

    set(${_return_var} ${__arch} PARENT_SCOPE)

endfunction()
