#=============================================================================#
# Sets compiler and linker flags on the given library target.
# Changes are kept even outside the scope of the function since they apply on a target.
#       _library_target - Name of the library target.
#       _board_id - Board ID associated with the library. Some flags require it.
#=============================================================================#
function(_set_library_flags _library_target _board_id)

    # Set C++ compiler flags
    get_cmake_compliant_language_name(cpp flags_language)
    set_compiler_target_flags(${_library_target} "${_board_id}" PUBLIC LANGUAGE ${flags_language})

    # Set linker flags
    set_linker_flags(${_library_target} "${_board_id}")

endfunction()

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
function(_get_library_architecture _library_properties_file _return_var)

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

#=============================================================================#
# Gets a filtered list of architectures that aren't compliant with the platform's architecture.
# For example: If a list contains 'avr' and 'nrf52', while our arch is 'avr', 'nrf52' will be returned.
#       _arch_list - List of all architectures probably read from a library's properties file
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Filtered list of architectures.
#=============================================================================#
function(_get_unsupported_architectures _arch_list _return_var)

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

function(find_arduino_library _target_name _library_name _board_id)

    set(library_path "${ARDUINO_SDK_LIBRARIES_PATH}/${_library_name}")
    set(library_properties_path "${library_path}/library.properties")

    if (NOT EXISTS "${library_properties_path}")
        message(SEND_ERROR "Couldn't find library named ${_library_name}")
    else () # Library is found
        _get_library_architecture("${library_properties_path}" lib_arch)
        if (lib_arch)
            if ("${lib_arch}" MATCHES "UNSUPPORTED")
                string(CONCAT error_message
                        "${_library_name} "
                        "library isn't supported on the platform's architecture "
                        "${ARDUINO_CMAKE_PLATFORM_ARCHITECTURE}")
                message(SEND_ERROR ${error_message})
            endif ()
        endif ()

        find_header_files("${library_path}/src" library_headers RECURSE)

        if (NOT library_headers)
            string(CONCAT error_message
                    "${_library_name} "
                    "doesn't have any header files under the 'src' directory")
            message(SEND_ERROR "${error_message}")
        else ()
            find_source_files("${library_path}/src" library_sources RECURSE)

            if (NOT library_sources)
                string(CONCAT error_message
                        "${_library_name} "
                        "doesn't have any source file under the 'src' directory")
                message(SEND_ERROR "${error_message}")
            else ()
                if (lib_arch) # Treat architecture-specific libraries differently
                    # Filter any sources that aren't supported by the platform's architecture
                    list(LENGTH lib_arch num_of_libs_archs)
                    if (${num_of_libs_archs} GREATER 1)
                        # Exclude all unsupported architectures, request filter in regex mode
                        _get_unsupported_architectures("${lib_arch}" arch_filter REGEX)
                        set(filter_type EXCLUDE)
                    else ()
                        set(arch_filter "src\\/[^/]+\\.|${lib_arch}")
                        set(filter_type INCLUDE)
                    endif ()
                    list(FILTER library_headers ${filter_type} REGEX ${arch_filter})
                    list(FILTER library_sources ${filter_type} REGEX ${arch_filter})
                endif ()

                add_library(${_target_name} STATIC
                        "${library_headers}" "${library_sources}")
                target_include_directories(${_target_name} PUBLIC "${library_path}/src")
                _set_library_flags(${_target_name} ${_board_id})
            endif ()
        endif ()
    endif ()

endfunction()

#=============================================================================#
# Links the given library target to the given "executable" target, but first,
# it adds core lib's include directories to the libraries include directories.
#       _target_name - Name of the "executable" target.
#       _library_target_name - Name of the library target.
#=============================================================================#
function(link_arduino_library _target_name _library_target_name)

    if (NOT TARGET ${_target_name})
        message(FATAL_ERROR "Target doesn't exist - It must be created first!")
    elseif (NOT TARGET ${_library_target_name})
        message(FATAL_ERROR "Library target doesn't exist - It must be created first!")
    elseif (NOT TARGET ${${_target_name}_CORE_LIB_TARGET})
        message(FATAL_ERROR "Core Library target doesn't exist. This is bad and should be reported")
    endif ()

    # First, include core lib's directories in library as well
    get_target_property(core_lib_includes ${${_target_name}_CORE_LIB_TARGET} INCLUDE_DIRECTORIES)
    target_include_directories(${_library_target_name} PRIVATE "${core_lib_includes}")

    # Now, link library to executable
    target_link_libraries(${_target_name} PRIVATE ${_library_target_name})

endfunction()
