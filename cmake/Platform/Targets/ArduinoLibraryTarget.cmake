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

function(find_arduino_library _target_name _library_name _board_id)

    set(library_path "${ARDUINO_SDK_LIBRARIES_PATH}/${_library_name}")

    if (NOT EXISTS "${library_path}/library.properties")
        message(SEND_ERROR "Couldn't find library named ${_library_name}")
    else () # Library is found
        find_header_files("${library_path}/src" library_headers)

        if (NOT library_headers)
            string(CONCAT error_message
                    "${_library_name} "
                    "doesn't have any header files under the 'src' directory")
            message(SEND_ERROR "${error_message}")
        else ()
            # For now, assume the source file is located in the same directory
            # ToDo: Handle situations when source file don't exist or located under additional dirs
            find_source_files("${library_path}/src" library_sources)

            if (NOT library_sources)
                string(CONCAT error_message
                        "${_library_name} "
                        "doesn't have any source file under the 'src' directory")
                message(SEND_ERROR "${error_message}")
            else ()
                message(STATUS "Adding lib target ${_target_name}")
                message(STATUS "Headers: ${library_headers}")
                message(STATUS "Sources: ${library_sources}")
                add_library(${_target_name} STATIC
                        "${library_headers}" "${library_sources}")
                target_include_directories(${_target_name} PUBLIC "${library_path}/src")
                _set_library_flags(${_target_name} ${_board_id})
            endif ()
        endif ()
    endif ()

endfunction()

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
