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

    set(extra_args ${ARGN})
    list(LENGTH extra_args num_of_extra_args)
    if (${num_of_extra_args} GREATER 0)
        list(GET extra_args 0 use_special_characters)
        if ("${use_special_characters}" STREQUAL "USE_SPECIAL_CHARACTER")
            set(use_special_characters TRUE)
        else ()
            set(use_special_characters FALSE)
        endif ()
        if (use_special_characters AND ${num_of_extra_args} GREATER 1)
            list(GET extra_args 1 special_character)
            list(GET extra_args 2 section_index)
        else ()
            set(section_index -1)
        endif ()
    endif ()

    set(message "${_message_prefix}")

    list(FILTER _inner_sections EXCLUDE REGEX "name")

    foreach (section ${_sections})
        set(index 0)
        string(APPEND message "[${${section}_name}: ")
        foreach (inner_section ${_inner_sections})
            if (${index} EQUAL ${section_index})
                string(APPEND message "${${section}_${inner_section}}${special_character} ")
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
            formatted_message USE_SPECIAL_CHARACTER "%" 3)

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
