#=============================================================================#
# Sets compiler and linker flags on the given library target.
# Changes are kept even outside the scope of the function since they apply on a target.
#       _library_target - Name of the library target.
#=============================================================================#
function(set_library_flags _library_target)

    parse_scope_argument(scope "${ARGN}"
            DEFAULT_SCOPE PUBLIC)

    # Infer target's type and act differently if it's an interface-library
    get_target_property(target_type ${_library_target} TYPE)

    set_target_compile_flags(${_library_target} ${scope})

    # Set linker flags
    set_target_linker_flags(${_library_target})

endfunction()
