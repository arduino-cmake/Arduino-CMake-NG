#=============================================================================#
# Checks whether the given header name is discoverable by the given target,
# i.e. whether it's part of the target's 'INCLUDE_DIRECTORIES' property.
#       _header_we - Name of a header to check its' discoverability.
#       _target_name - Name of a target to check discoverability against.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - True if discoverable, false otherwise.
#=============================================================================#
function(is_header_discoverable_by_target _header_we _target_name _return_var)

    get_target_include_directories(${_target_name} target_include_dirs)

    get_header_file(${_header_we} ${target_include_dirs} header_found)

    if (NOT header_found OR "${header_found}" MATCHES "NOTFOUND")
        set(_return_var FALSE PARENT_SCOPE)
    else ()
        set(_return_var TRUE PARENT_SCOPE)
    endif ()

endfunction()
