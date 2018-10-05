#=============================================================================#
# Gets a list of architectures supported by a library.
# The list is read from the given properties file, which includes metadata about the library.
#       _library_properties_file - Full path to a library's properties file
#                                  (usually named 'library,propertie').
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - List of architectures supported by the library or '*'
#                 if it's architecture-agnostic (Supports all arhcitectures).
#=============================================================================#
function(get_arduino_library_supported_architectures _library_properties_file _return_var)

    file(STRINGS ${_library_properties_file} library_properties)

    list(FILTER library_properties INCLUDE REGEX "arch")

    _get_property_value("${library_properties}" _library_arch_list)

    string(REPLACE "," ";" _library_arch_list ${_library_arch_list}) # Turn into a valid list

    set(${_return_var} ${_library_arch_list} PARENT_SCOPE)

endfunction()
