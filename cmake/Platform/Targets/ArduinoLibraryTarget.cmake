function(find_arduino_library _target_name _library_name)

    find_path(library_path
            NAME library.properties
            PATHS "${ARDUINO_SDK_LIBRARIES_PATH}"
            PATH_SUFFIXES "${_library_name}"
            NO_DEFAULT_PATH NO_CMAKE_PATH NO_CMAKE_FIND_ROOT_PATH)
    if (NOT library_path OR "${library_path}" MATCHES "NOTFOUND")
        message(SEND_ERROR "Couldn't find library named ${_library_name}")
    else () # Library is found
        find_file(library_main_header
                NAME "${_library_name}.h" "${_library_name}.hpp"
                PATHS "${library_path}"
                PATH_SUFFIXES src
                NO_DEFAULT_PATH NO_CMAKE_PATH NO_CMAKE_FIND_ROOT_PATH)
        if (NOT library_main_header OR "${library_main_header}" MATCHES "NOTFOUND")
            message(SEND_ERROR
                    "${_library_name} doesn't have a header file under the 'src' directory")
        else ()
            # For now, assume the source file is located in the same directory
            # ToDo: Handle situations when source file don't exist or located under additional dirs
            find_source_files("${library_path}/src" library_sources)
            if (NOT library_sources)
                message(SEND_ERROR
                        "${_library_name} doesn't have a source file under the 'src' directory")
            else ()
                add_library(${_target_name} STATIC
                        ${library_main_header} "${library_sources}")
                target_include_directories(${_target_name} PUBLIC "${library_path}/src")
            endif ()
        endif ()
    endif ()

endfunction()

function(link_arduino_library _target_name _library_target_name _board_id)

    if (NOT TARGET ${_target_name})
        message(FATAL_ERROR "Target doesn't exist - It must be created first!")
    elseif (NOT TARGET ${_library_target_name})
        message(FATAL_ERROR "Library target doesn't exist - It must be created first!")
    endif ()

    # First, link Core Lib to library
    get_target_property(core_lib_includes ${_board_id}_core_lib INCLUDE_DIRECTORIES)
    message("Core Library include dirs: ${core_lib_includes}")
    target_link_libraries(${_library_target_name} PUBLIC ${_board_id}_core_lib)
    get_target_property(lib_includes ${_library_target_name} INCLUDE_DIRECTORIES)
    message("Library include dirs: ${lib_includes}")

    # Now, link library to executable
    target_link_libraries(${_target_name} PRIVATE ${_library_target_name})

endfunction()
