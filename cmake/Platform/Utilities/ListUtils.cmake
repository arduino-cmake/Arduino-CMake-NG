#=============================================================================#
# Replaces an element at the given index with another element in the given list.
#       _list - List to replace one its' elements.
#       _index - Index of the element to replace.
#                Must not be negative or greater than 'list_length'-1.
#=============================================================================#
macro(list_replace _list _index _new_element)

    list(REMOVE_AT ${_list} ${_index})
    list(INSERT ${_list} ${_index} "${_new_element}")

endmacro()

#=============================================================================#
# Checks whether the given list is empty. If it is - Initializes it with a theoretically
# impossible to reproduce value, so if it's used to check whether an item is in it
# the answer will be false.
#       _list - List to initialize.
#=============================================================================#
macro(initialize_list _list)

    if ("${${_list}}" STREQUAL "")
        set(${_list} "+-*/")
    endif ()

endmacro()

#=============================================================================#
# Gets the maximal index a given list can relate to, i.e. the largest index, zero-counted.
# Usually it's just `length - 1`, but there are edge cases where special treatment must be applied.
#       _list - List to get its maximal index.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Maximal index the list can relate to (usually `length - 1`).
#=============================================================================#
function(list_max_index _list _return_var)

    list(LENGTH _list list_length)

    set(index ${list_length})
    if (${list_length} GREATER 0)
        decrement_integer(index 1)
    endif ()

    set(${_return_var} ${index} PARENT_SCOPE)

endfunction()
