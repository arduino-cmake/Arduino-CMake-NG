include(RecipePropertyValueResolver)

function(parse_compiler_recipe_flags _board_id _return_var)

    set(recipe_language cpp) # Use C++ by default
    set(original_list "${recipe_cpp_o_pattern}")
    set(final_recipe "")

    # Filter unwanted patterns from the recipe, so that only wanted ones will be parsed
    list(FILTER original_list INCLUDE REGEX "(^[^\"].+[^\"]$)")

    foreach (recipe_element ${recipe_cpp_o_pattern})
        _resolve_recipe_property("${recipe_element}" resolved_element)
        if (NOT "${resolved_element}" STREQUAL "") # Unresolved element, don't append
            list(APPEND final_recipe "${resolved_element}")
        endif ()
    endforeach ()

    set(${_return_var} "${final_recipe} " PARENT_SCOPE)

endfunction()
