include(SketchSourceConverter)
include(SketchLibraryFetcher)

#=============================================================================#
# Returns a desired path for sources converted from sketches.
# It can't be resolved just by a cache variable since sketches may belong each to a different project,
# thus having different path to be returned.
#       _sketch_file - Path to a sketch file to find the desired path to its converted source
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Desired path for the source file converted from the given sketch
#=============================================================================#
function(_get_converted_source_desired_path _sketch_file _return_var)

    get_filename_component(sketch_file_name "${_sketch_file}" NAME_WE)
    set(desired_source_path "${CMAKE_CURRENT_SOURCE_DIR}/${sketch_file_name}.cpp")
    set(${_return_var} ${desired_source_path} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Adds the sketch file to the given target with the given board ID.
# Each sketch is converted to a valid '.cpp' source file under the project's source directory.
# The function also finds and links any libraries the sketch uses to the target.
#       _target_name - Name of the target to add the sketch file to
#       _sketch_file - Path to a sketch file to add to the target
#       _board_id - ID of the board to bind to the target (Each target can have a single board).
#=============================================================================#
function(add_sketch_to_target _target_name _sketch_file _board_id)

    get_sketch_libraries("${_sketch_file}" sketch_libraries)
    foreach (lib ${sketch_libraries})
        if (${lib} IN_LIST ARDUINO_CMAKE_PLATFORM_LIBRARIES)
            link_platform_library(${_target_name} ${lib} ${_board_id})
        else ()
            find_arduino_library(${lib}_sketch_lib ${lib} ${_board_id})
            # If library isn't found, display a wraning since it might be a user library
            if (NOT ${lib}_sketch_lib OR "${${lib}_sketch_lib}" MATCHES "NOTFOUND")
                message(WARNING "The header '${lib}' is used by the '${_sketch_file}' sketch \
                                 but it isn't a known library - Target might not compile correctly!")
            else ()
                link_arduino_library(${_target_name} ${lib}_sketch_lib ${_board_id})
            endif ()
        endif ()
    endforeach ()

    _get_converted_source_desired_path("${_sketch_file}" sketch_converted_source_path)
    convert_sketch_to_source("${_sketch_file}" "${sketch_converted_source_path}")
    target_sources(${_target_name} PRIVATE "${sketch_converted_source_path}")

endfunction()

#=============================================================================#
# Converts all the given sketch file into valid 'cpp' source files and returns their paths.
#        _sketch_files - List of paths to original sketch files.
#        _return_var - Name of variable in parent-scope holding the return value.
#        Returns - List of paths representing post-conversion sources.
#=============================================================================#
function(get_sources_from_sketches _sketch_files _return_var)

    set(sources)
    foreach (sketch ${_sketch_files})
        get_filename_component(sketch_file_name "${sketch}" NAME_WE)
        set(target_source_path "${CMAKE_CURRENT_SOURCE_DIR}/${sketch_file_name}.cpp")
        # Only convert sketch if it hasn't been converted yet
        if (NOT EXISTS "${target_source_path}")
            convert_sketch_to_source("${sketch}" "${target_source_path}")
        endif ()
        list(APPEND sources "${target_source_path}")
    endforeach ()

    set(${_return_var} ${sources} PARENT_SCOPE)

endfunction()
