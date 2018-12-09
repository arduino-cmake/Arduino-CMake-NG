include(CoreLibTarget)

#========================================================================================================#
# Internal function that actually configures project for use with a given hardware board.
# Currently it only creates a Core-Library target based on the given board, which will be linked
# to every Arduino-target created afterwards.
#       _board_id - Complete ID of the board which will be used throughout the project.
#========================================================================================================#
function(_configure_arduino_board _board_id)

    add_arduino_core_lib(${_board_id})

endfunction()

#========================================================================================================#
# Configures CMake framework for use with the given Arduino hardware board.
# Note that it doesn't do anything that's actually related to hardware, this is simply configuration!
# This functio should be called at least once in each project, so targets created later could use the board.
#       _board_name - Name of the board, e.g. nano, uno, etc...
#       [] - Explicit board CPU if there are multiple versions of the board (such as atmega328p).
#            This is an argument variable which has no name and can be passed as the last argument when required.
#========================================================================================================#
function(configure_arduino_board _board_name _board_cpu)

    get_board_id(board_id ${_board_name} ${_board_cpu})

    _configure_arduino_board(${board_id})

endfunction()
