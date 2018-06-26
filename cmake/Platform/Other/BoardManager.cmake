#=============================================================================#
#        returns BOARD_ID constructing from _board_name and _board_cpu, 
#        if board doesn't has multiple cpus then BOARD_ID = _board_name.
#        If board has multiple CPUS, and _board_cpu is not defined or incorrect, 
#        fatal error will be invoked.
#
#       _return_var - Board ID constructed from board's name and CPU.
#       _board_name - name of the board, eg.: nano, uno, etc...
#       _board_cpu - explicit cpu of the board if there are multiple versions of the board.
#
#=============================================================================#
function(get_board_id _return_var _board_name)

    set(extra_args ${ARGN})
    list(LENGTH extra_args num_of_extra_args)
    if (${num_of_extra_args} GREATER 0)
        list(GET extra_args 0 _board_cpu)
    endif ()

    list(FIND ARDUINO_CMAKE_BOARDS ${_board_name} board_name_index)
    if (${board_name_index} LESS 0) # Negative value = not found in list
        message(FATAL_ERROR "Unknown given board name, not defined in 'boards.txt'. Check your\
        spelling.")
    else () # Board is valid and has been found
        if (DEFINED ${_board_name}_cpu_list) # Board cpu is to be expected
            if (NOT _board_cpu)
                message(FATAL_ERROR "Expected board CPU to be provided for the ${_board_name} board")
            else ()
                list(FIND ${_board_name}_cpu_list ${_board_cpu} board_cpu_index)
                if (${board_cpu_index} LESS 0)
                    message(FATAL_ERROR "Unknown given board cpu")
                endif ()
                set(board_id "${_board_name}.${_board_cpu}")
                set(${_return_var} "${board_id}" PARENT_SCOPE)
            endif ()
        else () # Board without explicit CPU
            set(${_return_var} ${_board_name} PARENT_SCOPE)
        endif ()
    endif ()

endfunction()

#=============================================================================#
# Gets board property.
# Reconstructs board_name and board_cpu from _board_id and tries to find value at 
# ${board_name}.${_property},
# if not found than try to find value at ${board_name}.menu.cpu.${board_cpu}.${_property}
# if not found that show fatal error
#
#       _board_id - return value from function "_get_board_id (board_name, board_cpu)".
#                   It contains board_name and board_cpu.
#       _property - property name for the board, eg.: bootloader.high_fuses
#       _return_var - Name of variable in parent-scope holding the return value.
#=============================================================================#
function(get_board_property _board_id _property _return_var)

    string(REPLACE "." ";" board_id "${_board_id}")
    string(REPLACE "." "_" property "${_property}")

    # Get the length of the board to determine whether board CPU is to be expected
    list(LENGTH board_id num_of_board_elements)
    list(GET board_id 0 board_name) # Get the board name which is mandatory

    if (DEFINED ${board_name}_${property})
        set(retrieved_property ${${board_name}_${property}})
    elseif (${num_of_board_elements} EQUAL 1) # Only board name is supplied
        message(WARNING "Property ${_property} couldn't be found on board ${_board_id}")
    else ()
        list(GET board_id 1 board_cpu)
        if (NOT DEFINED ${board_name}_menu_cpu_${board_cpu}_${property})
            message(WARNING "Property ${_property} couldn't be found on board ${_board_id}")
        else ()
            set(retrieved_property ${${board_name}_menu_cpu_${board_cpu}_${property}})
        endif ()
    endif ()

    set(${_return_var} ${retrieved_property} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Gets board property.
# Reconstructs board_name and board_cpu from _board_id and tries to find value at
# ${board_name}.${_property},
# if not found than try to find value at ${board_name}.menu.cpu.${board_cpu}.${_property}
# if not found that show fatal error
#
#       _board_id - return value from function "_get_board_id (board_name, board_cpu)".
#                   It contains board_name and board_cpu.
#       _property - property name for the board, eg.: bootloader.high_fuses
#       _return_var - Name of variable in parent-scope holding the return value.
#=============================================================================#
function(try_get_board_property _board_id _property _return_var)

    string(REPLACE "." ";" board_id "${_board_id}")
    string(REPLACE "." "_" property "${_property}")

    # Get the length of the board to determine whether board CPU is to be expected
    list(LENGTH board_id num_of_board_elements)
    list(GET board_id 0 board_name) # Get the board name which is mandatory

    if (DEFINED ${board_name}_${property})
        set(${_return_var} ${${board_name}_${property}} PARENT_SCOPE)
    elseif (${num_of_board_elements} EQUAL 1) # Only board name is supplied
        return()
    else ()
        list(GET board_id 1 board_cpu)
        if (NOT DEFINED ${board_name}_menu_cpu_${board_cpu}_${property})
            return()
        else ()
            set(${_return_var} ${${board_name}_menu_cpu_${board_cpu}_${property}} PARENT_SCOPE)
        endif ()
    endif ()

endfunction()
