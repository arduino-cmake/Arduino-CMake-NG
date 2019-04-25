function(get_source_function_definitions _source_file _return_var)

    file(STRINGS "${_source_file}" source_lines)

    foreach (line ${source_lines})
        if ("${line}" MATCHES "${ARDUINO_CMAKE_FUNCTION_DEFINITION_REGEX_PATTERN}")
            list(APPEND definitions "${line}")
        endif ()
    endforeach ()

    set(${_return_var} ${definitions} PARENT_SCOPE)

endfunction()