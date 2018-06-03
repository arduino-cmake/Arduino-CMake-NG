function(set_executable_target_flags _target_name _board_id)

    parse_compiler_recipe_flags(${_board_id} parsed_recipe)
    message("Parsed recipe: ${parsed_recipe}")

    target_compile_options(${_target_name} PUBLIC ${parsed_recipe})

endfunction()
