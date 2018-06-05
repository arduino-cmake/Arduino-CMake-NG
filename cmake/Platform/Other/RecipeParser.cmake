include(RecipePropertyValueResolver)

function(_determine_compiler_language _return_var)

    set(extra_args ${ARGN})
    list(LENGTH extra_args num_of_extra_args)
    if (${num_of_extra_args} GREATER 0)
        list(GET extra_args 0 language)
    else ()
        set(language cpp) # Use C++ by default
    endif ()

    # Convert language to expected recipe format
    if ("${language}" EQUAL "CXX")
        set(language cpp)
    else ()
        string(TOLOWER "${language}" language)
    endif ()

    set(${_return_var} "${language}" PARENT_SCOPE)

endfunction()

function(parse_compiler_recipe_flags _board_id _return_var)

    set(extra_args ${ARGN})

    _determine_compiler_language(recipe_language "${extra_args}")

    set(original_list "${recipe_${recipe_language}_o_pattern}")
    set(final_recipe "")

    # Filter unwanted patterns from the recipe, so that only wanted ones will be parsed
    list(FILTER original_list INCLUDE REGEX "(^[^\"].*[^\"]$)")
    list(FILTER original_list EXCLUDE REGEX "-o")

    foreach (recipe_element ${original_list})
        _resolve_recipe_property("${recipe_element}" resolved_element)
        if (NOT "${resolved_element}" STREQUAL "") # Unresolved element, don't append
            list(APPEND final_recipe "${resolved_element}")
        endif ()
    endforeach ()

    set(${_return_var} "${final_recipe} " PARENT_SCOPE)

endfunction()
