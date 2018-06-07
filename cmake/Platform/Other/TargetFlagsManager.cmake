function(set_executable_target_flags _target_name _board_id)

    parse_compiler_recipe_flags(${_board_id} parsed_recipe)
    target_compile_options(${_target_name} PUBLIC ${parsed_recipe})

endfunction()

function(set_upload_target_flags _target_name _board_id _upload_port _return_var)

    set(upload_flags "")

    # Parse and append recipe flags
    parse_upload_recipe_pattern(${_board_id} ${_upload_port} upload_recipe_flags)
    list(APPEND upload_flags "${upload_recipe_flags}")

    set(target_binary_base_path "${CMAKE_CURRENT_BINARY_DIR}/${_target_name}")

    list(APPEND upload_flags "-Uflash:w:\"${target_binary_base_path}.hex\":i")
    list(APPEND upload_flags "-Ueeprom:w:\"${target_binary_base_path}.eep\":i")

    set(${_return_var} ${upload_flags} PARENT_SCOPE)

endfunction()
