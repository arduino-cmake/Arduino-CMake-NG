macro(_cleanup_find_arduino_library)

    unset(library_path CACHE)

endmacro()

#=============================================================================#
# Finds an Arduino library with the given library name and creates a library target from it
# with the given target name.
# The search process also resolves library's architecture to check if it even can be built
# using the current platform architecture.
#       _target_name - Name of the library target to be created. Usually library's real name.
#       _library_name - Name of the Arduino library to find.
#       _board_id - Board ID associated with the linked Core Lib.
#       [3RD_PARTY] - Whether library should be treated as a 3rd Party library.
#       [HEADER_ONLY] - Whether library should be treated as header-only library.
#       [QUIET] - Whether function should "fail" safely without warnings/errors
#                 in case of an actual error.
#=============================================================================#
function(find_arduino_library _target_name _library_name _board_id)

    set(argument_options "3RD_PARTY" "HEADER_ONLY" "QUIET")
    cmake_parse_arguments(parsed_args "${argument_options}" "" "" ${ARGN})

    if (NOT parsed_args_3RD_PARTY)
        convert_string_to_pascal_case(${_library_name} _library_name)
    endif ()

    find_file(library_path
            NAMES ${_library_name}
            PATHS ${ARDUINO_SDK_LIBRARIES_PATH} ${ARDUINO_CMAKE_SKETCHBOOK_PATH}
            ${CMAKE_CURRENT_SOURCE_DIR} ${PROJECT_SOURCE_DIR}
            PATH_SUFFIXES libraries dependencies
            NO_DEFAULT_PATH
            NO_CMAKE_FIND_ROOT_PATH)

    if ("${library_path}" MATCHES "NOTFOUND" AND NOT parsed_args_QUIET)
        message(SEND_ERROR "Couldn't find library named ${_library_name}")

    else () # Library is found

        find_library_header_files("${library_path}" library_headers)

        if (NOT library_headers)
            if (parsed_args_QUIET)
                _cleanup_find_arduino_library()
                return()
            else ()
                message(SEND_ERROR "Couldn't find any header files for the "
                        "${_library_name} library")
            endif ()

        else ()

            if (parsed_args_HEADER_ONLY)
                add_arduino_header_only_library(${_target_name} ${_board_id} ${library_headers})

            else ()

                find_library_source_files("${library_path}" library_sources)

                if (NOT library_sources)
                    if (parsed_args_QUIET)
                        _cleanup_find_arduino_library()
                        return()
                    else ()
                        message(SEND_ERROR "Couldn't find any source files for the "
                                "${_library_name} library - Is it a header-only library?"
                                "If so, please pass the HEADER_ONLY option "
                                "as an argument to the function")
                    endif ()

                else ()

                    set(sources ${library_headers} ${library_sources})

                    add_arduino_library(${_target_name} ${_board_id} ${sources})

                endif ()

            endif ()

        endif ()

    endif ()

    _cleanup_find_arduino_library()

endfunction()
