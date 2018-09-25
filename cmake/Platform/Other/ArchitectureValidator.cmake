#=============================================================================#
# Gets a filtered list of architectures that aren't compliant with the platform's architecture.
# e.g If a list contains 'avr' and 'nrf52', while our arch is 'avr', 'nrf52' will be returned.
#       _arch_list - List of all architectures probably read from a library's properties file
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Filtered list of architectures.
#=============================================================================#
function(get_unsupported_architectures _arch_list _return_var)

    cmake_parse_arguments(unsupported_archs "REGEX" "" "" ${ARGN})

    list(FILTER _arch_list EXCLUDE REGEX
            "${ARDUINO_CMAKE_PLATFORM_ARCHITECTURE}")
    if (unsupported_archs_REGEX) # Return in regex format
        list(LENGTH _arch_list num_of_unsupported_archs)
        set(unsupported_arch_list "")
        set(arch_index 1)
        foreach (unsupported_arch ${_arch_list})
            string(APPEND unsupported_arch_list "${unsupported_arch}")
            if (${arch_index} LESS ${num_of_unsupported_archs})
                string(APPEND unsupported_arch_list "|")
            endif ()
            increment_integer(arch_index 1)
        endforeach ()
    endif ()

    set(${_return_var} ${unsupported_arch_list} PARENT_SCOPE)

endfunction()
