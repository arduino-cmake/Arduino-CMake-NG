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
        get_library_architecture("${library_properties_file}" lib_arch)
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
