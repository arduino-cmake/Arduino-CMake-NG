#=============================================================================#
# Replaces an element at the given index with another element in the given list.
#       _list - List to replace one its' elements.
#       _index - Index of the element to replace.
#                Must not be negative or greater than the length of the list-1.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - New list with new, replaced elements in it.
#=============================================================================#
function(list_replace _list _index _new_element _return_var)
    list(REMOVE_AT _list ${_index})
    list(INSERT _list ${_index} "${_new_element}")
    set(${_return_var} "${_list}" PARENT_SCOPE)
endfunction()
