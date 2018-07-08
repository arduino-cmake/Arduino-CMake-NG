include(ArduinoLibraryParser)

function(find_dependent_platform_libraries _sources _return_var)

    set(includes)
    foreach (source ${_sources})
        get_source_file_includes(${source} source_includes)
        list(APPEND includes ${source_includes})
    endforeach ()

    list(REMOVE_DUPLICATES includes)

    get_platform_libraries_from_includes("${includes}" dependent_libs)
    set(${_return_var} ${dependent_libs} PARENT_SCOPE)

endfunction()

function(_add_platform_library _library_name _board_id)

    find_header_files("${ARDUINO_CMAKE_PLATFORM_LIBRARIES_PATH}/${_library_name}/src" lib_headers)
    find_source_files("${ARDUINO_CMAKE_PLATFORM_LIBRARIES_PATH}/${_library_name}/src" lib_source_files)
    set(lib_sources ${lib_headers} ${lib_source_files})

    _add_arduino_cmake_library(${_library_name} ${_board_id} "${lib_sources}")

endfunction()

function(link_platform_library _target_name _library_name _board_id)

    if (NOT TARGET ${_target_name})
        message(FATAL_ERROR "Target ${_target_name} doesn't exist - It must be created first!")
    endif ()

    if (NOT TARGET ${_library_name})
        _add_platform_library(${_library_name} ${_board_id})
    endif ()

    get_core_lib_target_name(${_board_id} core_lib_target)
    _link_arduino_cmake_library(${_target_name} ${_library_name}
            PUBLIC
            BOARD_CORE_TARGET ${core_lib_target})

endfunction()
