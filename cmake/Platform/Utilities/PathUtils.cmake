#=============================================================================#
# Finds the shallowest path among the given sources, where shallowest is the path having
# the least nesting level, i.e. The least number of '/' separators in its' path.
#       _sources - List of sources paths to find shallowest path from.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Shallowest path among given sources (Lowest nesting level).
#=============================================================================#
function(get_shallowest_directory_structure_path _sources _return_var)

    set(min_nesting_level 9999)

    foreach (source ${_sources})

        string(REGEX MATCHALL "/" nesting_regex_match ${source})

        list(LENGTH nesting_regex_match source_nesting_level)

        if (${source_nesting_level} LESS ${min_nesting_level})
            set(min_nested_path ${source})
            set(min_nesting_level ${source_nesting_level})
        endif ()

    endforeach ()

    set(${_return_var} ${min_nested_path} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Gets the path of the common root directory of all given sources.
# It is expected that indeed all sources will have the same, common root directory.
# E.g. src/foo.h and src/utility/bar.h both have 'src' in common.
# However, if src/foo.c is a relative path under the C:\ drive (in Windows), and src/bar.c is
# a relative path under the D:\ drive - This is invalid and the function will misbehave.
#       _sources - List of sources that have a common root directory which needs to be found.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Path to the common root directory of the given list of sources.
#=============================================================================#
function(get_sources_root_directory _sources _return_var)

    get_shallowest_directory_structure_path("${_sources}" shallowest_path)

    get_filename_component(root_dir ${shallowest_path} DIRECTORY)

    if ("${root_dir}" MATCHES ".+src$") # 'src' directory has been retrieved as shallowest path
        # The actual root directory is one level above 'src'
        get_filename_component(root_dir ${root_dir} DIRECTORY)
    endif ()

    set(${_return_var} ${root_dir} PARENT_SCOPE)

endfunction()
