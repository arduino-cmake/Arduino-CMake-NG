include(SketchSourceConverter)
include(SketchHeadersManager)

#=============================================================================#
# Returns a desired path for sources converted from sketches.
# It can't be resolved just by a cache variable since sketches may belong each to a different project,
# thus having different path to be returned.
#       _sketch_file - Path to a sketch file to find the desired path to its converted source.
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
#       _target_name - Name of the target to add the sketch file to.
#       _board_id - ID of the board to bind to the target (Each target can have a single board).
#       _sketch_file - Path to a sketch file to add to the target.
#=============================================================================#
function(add_sketch_to_target _target_name _board_id _sketch_file)

    _get_converted_source_desired_path(${_sketch_file} sketch_converted_source_path)

    # Only perform conversion if policy is set or if sketch hasn't been converted yet
    if (CONVERT_SKETCHES_IF_CONVERTED_SOURCES_EXISTS OR
            NOT EXISTS ${sketch_converted_source_path})

        resolve_sketch_headers(${_target_name} ${_board_id} ${_sketch_file})

        convert_sketch_to_source(${_sketch_file} ${sketch_converted_source_path})

    endif ()

    target_sources(${_target_name} PRIVATE ${sketch_converted_source_path})

endfunction()

#=============================================================================#
# Adds a list of sketch files as converted sources to the given target.
#       _target_name - Name of the target to add the sketch file to.
#       _board_id - ID of the board to bind to the target (Each target can have a single board).
#       [Sketches] - List of paths to sketch files to add to the target.
#=============================================================================#
function(target_sketches _target_name _board_id)

    parse_sources_arguments(parsed_sketches "" "" "" "${ARGN}")

    foreach (sketch_file ${parsed_sketches})
        add_sketch_to_target(${_target_name} ${_board_id} ${sketch_file})
    endforeach ()

endfunction()
