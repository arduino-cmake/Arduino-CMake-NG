function(get_arduino_library_supported_architectures _library_properties_file _return_var)

    file(STRINGS ${_library_properties_file} library_properties)

    list(FILTER library_properties INCLUDE REGEX "arch")
    _get_property_value("${library_properties}" _library_arch_list)
    string(REPLACE "," ";" _library_arch_list ${_library_arch_list}) # Turn into a valid list

    set(${_return_var} ${_library_arch_list} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Gets the library architecure if any, read from the given library properties file
# which includes this information.
#       _library_arch_list - List of architectures supported by the library,
#                    inferred from its' 'library.properties' file.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - If library is architecure agnostic (Supports all), nothing is returned.
#                 If library doesn't support the current platform's architecture,
#                 "UNSUPPORTED" string is returned.
#                 Otherwise, the platform's architecture is returned.
#=============================================================================#
function(is_library_supports_platform_architecture _library_arch_list _return_var)

    if ("${_library_arch_list}" MATCHES "\\*") # Any architecture is supported
        set(result TRUE)
    else ()
        if (${ARDUINO_CMAKE_PLATFORM_ARCHITECTURE} IN_LIST _library_arch_list)
            set(result TRUE) # Our platform's arch is supported
        else ()
            set(result FALSE) # Our arch isn't supported
        endif ()
    endif ()

    set(${_return_var} ${result} PARENT_SCOPE)

endfunction()
