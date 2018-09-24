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

#=============================================================================#
# Creates a library target for the given name and sources.
# As it's an Arduino library, it also finds and links all dependent platform libraries (if any).
#       _target_name - Name of the library target to be created. Usually library's real name.
#       _board_id - Board ID associated with the linked Core Lib.
#       _sources - Source and header files to create target from.
#=============================================================================#
function(add_arduino_library _target_name _board_id _sources)

    _add_arduino_cmake_library(${_target_name} ${_board_id} "${_sources}" "${ARGN}")
    find_dependent_platform_libraries("${_sources}" lib_platform_libs)
    foreach (platform_lib ${lib_platform_libs})
        link_platform_library(${_target_name} ${platform_lib} ${_board_id})
    endforeach ()

endfunction()

function(add_arduino_header_only_library _target_name _board_id)

    cmake_parse_arguments(parsed_args "ARCH" "" "HEADERS" ${ARGN})

    _add_arduino_cmake_library(${_target_name} ${_board_id} "${parsed_args_HEADERS}"
            INTERFACE ${parsed_args_ARCH})

endfunction()

#=============================================================================#
# Finds an Arduino library with the given library name and creates a library target from it
# with the given target name.
# The search process also resolves library's architecture to check if it even can be built
# using the current platform architecture.
#       _target_name - Name of the library target to be created. Usually library's real name.
#       _library_name - Name of the Arduino library to find.
#       _board_id - Board ID associated with the linked Core Lib.
#       [3RD_PARTY] - Whether library should be treated as a 3rd Party library.
#       [HEADER_ONLY] - Whether library is a header-only library, i.e has no source files
#=============================================================================#
function(find_arduino_library _target_name _library_name _board_id)

    set(argument_options "3RD_PARTY" "HEADER_ONLY")
    cmake_parse_arguments(parsed_args "${argument_options}" "" "" ${ARGN})

    if (NOT parsed_args_3RD_PARTY)
        convert_string_to_pascal_case(${_library_name} _library_name)
    endif ()

    find_file(library_properties_file library.properties
            PATHS ${ARDUINO_SDK_LIBRARIES_PATH} ${ARDUINO_CMAKE_SKETCHBOOK_PATH}/libraries
            PATH_SUFFIXES ${_library_name}
            NO_DEFAULT_PATH
            NO_CMAKE_FIND_ROOT_PATH)

    if (${library_properties_file} MATCHES "NOTFOUND")
        message(SEND_ERROR "Couldn't find library named ${_library_name}")
    else () # Library is found
        get_filename_component(library_path ${library_properties_file} DIRECTORY)
        _get_library_architecture("${library_properties_file}" lib_arch)
        if (lib_arch)
            if ("${lib_arch}" MATCHES "UNSUPPORTED")
                string(CONCAT error_message
                        "${_library_name} "
                        "library isn't supported on the platform's architecture "
                        "${ARDUINO_CMAKE_PLATFORM_ARCHITECTURE}")
                message(SEND_ERROR ${error_message})
            endif ()
        endif ()

        find_library_header_files("${library_path}" library_headers)
        if (NOT library_headers)
            set(error_message "Couldn't find any header files for the ${_library_name} library")
            message(SEND_ERROR "${error_message}")
        else ()
            if (parsed_args_HEADER_ONLY)
                add_arduino_header_only_library(${_target_name} ${_board_id}
                        ARCH ${lib_arch}
                        HEADERS ${library_headers})
            else ()
                find_library_source_files("${library_path}" library_sources)
                if (NOT library_sources)
                    string(CONCAT error_message
                            "Couldn't find any source files for the ${_library_name} library - "
                            "Is it a header-only library?\n"
                            "If so, please pass the HEADER_ONLY option as an argument to the function")
                    message(SEND_ERROR "${error_message}")
                else ()
                    set(sources ${library_headers} ${library_sources})
                    add_arduino_library(${_target_name} ${_board_id} "${sources}"
                            ARCH ${lib_arch})
                endif ()
            endif ()
        endif ()
    endif ()

    unset(library_properties_file CACHE)

endfunction()

#=============================================================================#
# Links the given library target to the given "executable" target, but first,
# it adds core lib's include directories to the libraries include directories.
#       _target_name - Name of the "executable" target.
#       _library_target_name - Name of the library target.
#       _board_id - Board ID associated with the linked Core Lib.
#       [HEADER_ONLY] - Whether library is a header-only library, i.e has no source files
#=============================================================================#
function(link_arduino_library _target_name _library_target_name _board_id)

    cmake_parse_arguments(parsed_args "HEADER_ONLY" "" "" ${ARGN})

    get_core_lib_target_name(${_board_id} core_lib_target)

    if (NOT TARGET ${_target_name})
        message(FATAL_ERROR "Target doesn't exist - It must be created first!")
    elseif (NOT TARGET ${_library_target_name})
        message(FATAL_ERROR "Library target doesn't exist - It must be created first!")
    elseif (NOT TARGET ${core_lib_target})
        message(FATAL_ERROR "Core Library target doesn't exist. This is bad and should be reported")
    endif ()

    if (parsed_args_HEADER_ONLY)
        _link_arduino_cmake_library(${_target_name} ${_library_target_name}
                INTERFACE
                BOARD_CORE_TARGET ${core_lib_target})
    else ()
        _link_arduino_cmake_library(${_target_name} ${_library_target_name}
                PUBLIC
                BOARD_CORE_TARGET ${core_lib_target})
    endif ()

endfunction()
