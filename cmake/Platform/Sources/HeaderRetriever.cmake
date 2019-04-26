#=============================================================================#
# Retrieves full path to the file associated with the given header name,
# which should be located under one of the directories in the given list.
# The search is performed recursively (i.e. including sub-dirs) by default.
# If the header can't be found, "NOTFOUND" string is returned.
#       _header_we - Name of a header file which should be retrieved.
#       _dir_list - List of directories which could contain the searched header file.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Full path to the header file associated with the given header name, "NOTFOUND" if can't be found.
#=============================================================================#
function(get_header_file _header_we _dir_list _return_var)

    foreach (include_dir ${_dir_list})

        find_header_files("${include_dir}" include_dir_headers RECURSE)

        foreach (included_header ${include_dir_headers})
            get_name_without_file_extension("${included_header}" included_header_we)
            if ("${included_header_we}" STREQUAL "${_header_we}")
                set(${_return_var} ${included_header} PARENT_SCOPE)
                return()
            endif ()
        endforeach ()

    endforeach ()

    set(${_return_var} "NOTFOUND" PARENT_SCOPE)

endfunction()
