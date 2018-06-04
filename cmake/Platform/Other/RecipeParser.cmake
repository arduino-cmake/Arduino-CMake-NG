include(RecipePropertyValueResolver)

function(parse_compiler_recipe_flags _board_id _return_var)

    set(recipe_language cpp) # Use C++ by default
    set(final_recipe "")

    foreach (recipe_element ${recipe_cpp_o_pattern})
        string(REGEX MATCH "path|cmd" non_flag_element "${recipe_element}")
        if ("${non_flag_element}" STREQUAL "") # Element IS a flag, parse it
            # Element is wrapped with brackets = hasn't been resolved earlier and should be ommited
            string(REGEX MATCH "^[{\"].+[}\"]$" unresolved_element "${recipe_element}")
            if (NOT "${unresolved_element}" STREQUAL "") # Element is unresolved but should be
                continue()
            endif ()

            # Resolve element by searching it in the board's properties
            _resolve_recipe_property("${recipe_element}" resolved_element)
            if (NOT "${resolved_element}" STREQUAL "")
                list(APPEND final_recipe "${resolved_element}")
            endif ()
        endif ()
    endforeach ()

    set(${_return_var} "${final_recipe} " PARENT_SCOPE)

endfunction()
