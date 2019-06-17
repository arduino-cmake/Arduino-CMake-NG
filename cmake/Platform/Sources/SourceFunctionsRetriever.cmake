function(get_source_function_definitions _source_file _return_var)

    get_property(function_definition_regex GLOBAL PROPERTY ARDUINO_CMAKE_FUNCTION_DEFINITION_REGEX_PATTERN)

    file(STRINGS "${_source_file}" source_lines)

    foreach (line ${source_lines})
        if ("${line}" MATCHES "${function_definition_regex}")
            list(APPEND definitions "${line}")
        endif ()
    endforeach ()

    set(${_return_var} ${definitions} PARENT_SCOPE)

endfunction()