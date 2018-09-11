include(PropertyValueResolver)

#=============================================================================#
# Gets the name of the property from the given property-line (Combining both name and value).
# Name of the property is the string usually located before the '=' char.
#       _property - Full property as a property-line.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Extracted property name from the given property-line.
#=============================================================================#
function(_get_property_name _property _return_var)

    string(REGEX MATCH "^[^=]+" property_name "${_property}")
    set(${_return_var} "${property_name}" PARENT_SCOPE)

endfunction()

#=============================================================================#
# Gets the value of the property from the given property-line (Combining both name and value).
# Value of the property is the string usually located after the '=' char.
#       _property - Full property as a property-line.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Extracted property value from the given property-line.
#=============================================================================#
function(_get_property_value _property _return_var)

    string(REGEX REPLACE "^[^=]+=(.*)" "\\1" property_value "${_property}")
    string(STRIP "${property_value}" property_value)

    set(${_return_var} "${property_value}" PARENT_SCOPE)

endfunction()
