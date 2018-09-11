include(RecipePropertyValueResolver)

function(_determine_compiler_language _language _return_var)

    if (NOT _language) # Use default language
        set(language cpp)
    else ()
        # Convert language to expected recipe format
        get_arduino_compliant_language_name(${_language} language)
    endif ()

    set(${_return_var} "${language}" PARENT_SCOPE)

endfunction()

function(parse_compiler_recipe_flags _board_id _return_var)

    set(single_args "LANGUAGE")
    cmake_parse_arguments(recipe_flags "" "${single_args}" "" ${ARGN})

    _determine_compiler_language("${recipe_flags_LANGUAGE}" recipe_language)

    set(original_list "${recipe_${recipe_language}_o_pattern}")
    set(final_recipe "")

    # Filter unwanted patterns from the recipe, so that only wanted ones will be parsed
    list(FILTER original_list INCLUDE REGEX "(^[^\"].*[^\"]$)")
    list(FILTER original_list EXCLUDE REGEX "-o")

    foreach (recipe_element ${original_list})
        _resolve_recipe_property("${recipe_element}" "${_board_id}" resolved_element)
        if (NOT "${resolved_element}" STREQUAL "") # Unresolved element, don't append
            list(APPEND final_recipe "${resolved_element}")
        endif ()
    endforeach ()

    set(${_return_var} "${final_recipe} " PARENT_SCOPE)

endfunction()

function(parse_linker_recpie_pattern _board_id _return_var)

    set(original_list "${recipe_c_combine_pattern}")
    set(final_recipe "")

    # Filter unwanted patterns from the recipe, so that only wanted ones will be parsed
    list(FILTER original_list INCLUDE REGEX "(^[^\"].*[^\"]$)")
    list(FILTER original_list EXCLUDE REGEX "-[ol]")

    foreach (recipe_element ${original_list})
        _resolve_recipe_property("${recipe_element}" "${_board_id}" resolved_element)
        if (NOT "${resolved_element}" STREQUAL "") # Unresolved element, don't append
            list(APPEND final_recipe "${resolved_element}")
        endif ()
    endforeach ()

    set(${_return_var} "${final_recipe} " PARENT_SCOPE)

endfunction()

function(parse_upload_recipe_pattern _board_id _port _return_var)

    set(original_list "${tools_avrdude_upload_pattern}")
    set(final_recipe "")

    list(FILTER original_list EXCLUDE REGEX ":|cmd")

    # Upload recipe contains many elements which aren't named correctly
    # Setting a local variable here will keep it in the resolving function's scope
    # In other words, it makes the variable resolvable
    # So if a special elment is met, its' expected variable is locally set with correct value
    foreach (recipe_element ${original_list})
        if ("${recipe_element}" MATCHES "config.path")
            set(config_path "${ARDUINO_CMAKE_AVRDUDE_CONFIG_PATH}")
        elseif ("${recipe_element}" MATCHES "upload.verbose")
            set(upload_verbose "${tools_avrdude_upload_params_verbose}")
        elseif ("${recipe_element}" MATCHES "upload.verify")
            set(upload_verify "${tools_avrdude_upload_verify}")
        elseif ("${recipe_element}" MATCHES "protocol")
            set(protocol "${${_board_id}_upload_protocol}")
        elseif ("${recipe_element}" MATCHES "serial.port")
            set(serial_port "${_port}")
        endif ()

        _resolve_recipe_property("${recipe_element}" "${_board_id}" resolved_element)
        if (NOT "${resolved_element}" STREQUAL "")
            list(APPEND final_recipe "${resolved_element}")
        endif ()
    endforeach ()

    set(${_return_var} "${final_recipe}" PARENT_SCOPE)

endfunction()
