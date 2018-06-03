include(PropertyValueResolver)

function(_get_property_name _property _return_var)

    string(REGEX MATCH "^[^=]+" property_name "${_property}")
    set(${_return_var} "${property_name}" PARENT_SCOPE)

endfunction()

function(_get_property_value _property _return_var)

    string(REGEX REPLACE "^[^=]+=(.*)" "\\1" property_value "${_property}")
    string(STRIP "${property_value}" property_value)

    set(${_return_var} "${property_value}" PARENT_SCOPE)

endfunction()
