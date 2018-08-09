#=============================================================================#
# Increments the given integer by the requested amount.
# Note that this is a macro so it applies directly on the calling scope.
#       _integer_var - Name of the integer variable to increment.
#       _increment - Amount to increment the given integer by.
#       Returns - Incremented integer. Return value isn't required since it's a macro.
#=============================================================================#
macro(increment_integer _integer_var _increment)
    math(EXPR ${_integer_var} "${${_integer_var}}+${_increment}")
endmacro()

#=============================================================================#
# Decrements the given integer by the requested amount.
# Note that this is a macro so it applies directly on the calling scope.
#       _integer_var - Name of the integer variable to decrement.
#       _decrement - Amount to decrement the given integer by.
#       Returns - Decremented integer. Return value isn't required since it's a macro.
#=============================================================================#
macro(decrement_integer _integer_var _decrement)
    math(EXPR ${_integer_var} "${${_integer_var}}-${_decrement}")
endmacro()
