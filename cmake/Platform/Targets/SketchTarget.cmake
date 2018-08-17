#=============================================================================#
# Adds/Creates an Arduino-Executable target with the given name,
# using the given board ID and sketch file (.ino or .pde extension).
#       _target_name - Name of the target (Executable) to create.
#       _board_id - ID of the board to bind to the target (Each target can have a single board).
#       _sketch_file - List of paths to sketch files which the program must rely on.
#=============================================================================#
function(add_sketch_target _target_name _board_id _sketch_file)

    get_sources_from_sketches("${_sketch_file}" sketch_source)
    add_arduino_executable(${_target_name} ${_board_id} ${_sketch_file})

endfunction()
