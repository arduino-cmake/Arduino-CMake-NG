cmake_minimum_required(VERSION 3.8)

function(parse_list_entry _list _entry_pattern _entry_index _parsed_variables_prefix)

    set(temp_list "${_list}")
    list(FILTER temp_list INCLUDE REGEX "${_entry_pattern}")
    list(GET temp_list ${_entry_index} entry_to_parse)

    if ("${entry_to_parse}" MATCHES "([^:]+):[ \t]*([0-9]+)[ \t]*([^ \t]+)[ \t]*[(]([0-9.]+)%.*")
        set(${_parsed_variables_prefix}_name ${CMAKE_MATCH_1} PARENT_SCOPE)
        set(${_parsed_variables_prefix}_size ${CMAKE_MATCH_2} PARENT_SCOPE)
        set(${_parsed_variables_prefix}_size_type ${CMAKE_MATCH_3} PARENT_SCOPE)
        set(${_parsed_variables_prefix}_percent ${CMAKE_MATCH_4} PARENT_SCOPE)
    endif ()

endfunction()

function(format_output_message _message_prefix _sections _inner_sections _message_suffix
        _return_var)

    set(options USE_CUSTOM_CHARACTERS)
    set(multi_args CUSTOM_CHARACTERS CUSTOM_CHAR_INDICES)
    cmake_parse_arguments(format_args "${options}" "" "${multi_args}" ${ARGN})

    if (format_args_USE_CUSTOM_CHARACTERS)
        if (NOT format_args_CUSTOM_CHARACTERS OR NOT format_args_CUSTOM_CHAR_INDICES)
            set(valid_custom_chars FALSE)
            string(CONCAT message_str "If custom characters are to be used"
                    "," "they must also be provided" "," "along with their indices")
            message(WARNING "${message_str}")
        else ()
            set(valid_custom_chars TRUE)
        endif ()
    endif ()

    set(message "${_message_prefix}")

    # Exclude "name" inner-section as it's treated differently
    list(FILTER _inner_sections EXCLUDE REGEX "name")
    # Decrement all custom chars' indices if they should be used since the "name" has been removed
    if (valid_custom_chars)
        set(new_custom_char_indices "")
        foreach (char ${format_args_CUSTOM_CHAR_INDICES})
            math(EXPR char "${char}-1")
            list(APPEND new_custom_char_indices ${char})
        endforeach ()
        set(format_args_CUSTOM_CHAR_INDICES "${new_custom_char_indices}")
    endif ()

    foreach (section ${_sections})
        set(index 0)
        string(APPEND message "[${${section}_name}: ")
        foreach (inner_section ${_inner_sections})
            if (valid_custom_chars AND ${index} IN_LIST format_args_CUSTOM_CHAR_INDICES)
                string(APPEND message "${${section}_${inner_section}}")
                string(APPEND message "${format_args_CUSTOM_CHARACTERS} ")
            else ()
                string(APPEND message "${${section}_${inner_section}} ")
            endif ()
            math(EXPR index "${index}+1")
        endforeach ()
        string(APPEND message "] ")
    endforeach ()

    string(APPEND message "${_message_suffix}")

    set(${_return_var} "${message}" PARENT_SCOPE)

endfunction()

function(_get_image_type_parsing_index _image_type _return_var)

    string(TOLOWER "${_image_type}" image_type)

    if ("${image_type}" MATCHES "firmware")
        set(parsing_index 0)
    elseif ("${image_type}" MATCHES "eeprom")
        set(parsing_index 1)
    elseif ("${image_type}" MATCHES "flash")
        set(parsing_index 2)
    endif ()

    set(${_return_var} ${parsing_index} PARENT_SCOPE)

endfunction()

function(format_image_size _original_size_list _image_type _return_var)

    _get_image_type_parsing_index("${_image_type}" image_index)

    parse_list_entry("${_original_size_list}" "Program:" ${image_index} program_entry)
    parse_list_entry("${_original_size_list}" "Data:" ${image_index} data_entry)

    set(sections "program_entry" "data_entry")
    format_output_message("${_image_type} Size: " "${sections}" "${inner_sections}" "on ${MCU}"
            formatted_message USE_CUSTOM_CHARACTERS CUSTOM_CHARACTERS "%" CUSTOM_CHAR_INDICES 3)

    set(${_return_var} "${formatted_message}" PARENT_SCOPE)

endfunction()

set(avrsize_flags -C --mcu=${MCU})
execute_process(COMMAND ${AVRSIZE_PROGRAM} ${avrsize_flags} ${FIRMWARE_IMAGE} ${EEPROM_IMAGE}
        OUTPUT_VARIABLE firmware_size)

# Convert lines into a list
string(REPLACE "\n" ";" firmware_size_as_list "${firmware_size}")
list(FILTER firmware_size_as_list INCLUDE REGEX ".+")

set(inner_sections name size size_type percent)

# Process Firmware size
format_image_size("${firmware_size_as_list}" Firmware firmware_formatted_message)
# Process EEPROM size
format_image_size("${firmware_size_as_list}" EEPROM eeprom_formatted_message)

message("${firmware_formatted_message}")
message("${eeprom_formatted_message}\n")
