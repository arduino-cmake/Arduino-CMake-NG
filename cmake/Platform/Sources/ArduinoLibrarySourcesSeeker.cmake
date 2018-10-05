#=============================================================================#
# Recursively finds header files under the given path, excluding those that don't belong to a library,
# such as files under the 'exmaples' directory (In case sources reside under lib's root directory).
#        _base_path - Top-Directory path to search source files in.
#        _return_var - Name of variable in parent-scope holding the return value.
#        Returns - List of source files in the given path
#=============================================================================#
function(find_library_header_files _base_path _return_var)

    if (EXISTS ${_base_path}/src) # 'src' sub-dir exists and should contain sources

        # Headers are always searched recursively under the 'src' sub-dir
        find_header_files(${_base_path}/src headers RECURSE)

    else ()

        # Both root-dir and 'utility' sub-dir are searched when 'src' doesn't exist
        find_header_files(${_base_path} root_headers)
        find_header_files(${_base_path}/utility utility_headers)

        set(headers ${root_headers} ${utility_headers})

    endif ()

    set(${_return_var} "${headers}" PARENT_SCOPE)

endfunction()

#=============================================================================#
# Recursively finds source files under the given path, excluding those that don't belong to a library,
# such as files under the 'exmaples' directory (In case sources reside under lib's root directory).
#        _base_path - Top-Directory path to search source files in.
#        _return_var - Name of variable in parent-scope holding the return value.
#        Returns - List of source files in the given path
#=============================================================================#
function(find_library_source_files _base_path _return_var)

    if (EXISTS ${_base_path}/src)

        # Sources are always searched recursively under the 'src' sub-dir
        find_source_files(${_base_path}/src sources RECURSE)

    else ()

        # Both root-dir and 'utility' sub-dir are searched when 'src' doesn't exist
        find_source_files(${_base_path} root_sources)
        find_source_files(${_base_path}/utility utility_sources)

        set(sources ${root_sources} ${utility_sources})

    endif ()

    set(${_return_var} "${sources}" PARENT_SCOPE)

endfunction()
