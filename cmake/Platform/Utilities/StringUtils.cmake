#=============================================================================#
# Converts the given language string to a format recognized by CMake, thus 'compliant'.
# Language means programming language, such as 'C++', which gets converted to 'CXX'.
#       _language - Language to get its' CMake-Compliant version.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - CMake-Compliant version of the given language.
#                 If input language is invalid, an error is printed.
#=============================================================================#
function(get_cmake_compliant_language_name _language _return_var)

    string(TOLOWER "${_language}" language)

    if ("${language}" STREQUAL "s" OR "${language}" STREQUAL "asm")
        set(language ASM)
    elseif ("${language}" STREQUAL "cpp" OR "${language}" STREQUAL "cxx" OR
            "${language}" STREQUAL "c++")
        set(language CXX)
    elseif ("${language}" STREQUAL "c")
        set(language C)
    else ()
        message(SEND_ERROR "Invalid language given, must be C, C++ or ASM")
    endif ()

    set(${_return_var} ${language} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Converts the given language string to a format recognized by Arduino, thus 'compliant'.
# Language means programming language, such as 'C++', which gets converted to 'cpp'.
#       _language - Language to get its' Arduino-Compliant version.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Arduino-Compliant version of the given language.
#                 If input language is invalid, an error is printed.
#=============================================================================#
function(get_arduino_compliant_language_name _language _return_var)

    string(TOLOWER "${_language}" language)

    if ("${language}" STREQUAL "s" OR "${language}" STREQUAL "asm")
        set(language S) # Intentionally upper-case
    elseif ("${language}" STREQUAL "cpp" OR "${language}" STREQUAL "cxx" OR
            "${language}" STREQUAL "c++")
        set(language cpp)
    elseif ("${language}" STREQUAL "c")
        set(language c)
    else ()
        message(SEND_ERROR "Invalid language given, must be C, C++ or ASM")
    endif ()

    set(${_return_var} ${language} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Creates a name valid for Core libraries using the given board ID.
# The created name is lower-case 'Board-ID_core_lib'.
#       _board_id - Board ID to create core library target for.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Name of the core library target for the given board.
#=============================================================================#
function(generate_core_lib_target_name _board_id _return_var)

    string(REPLACE "." "_" board_id "${_board_id}")

    string(TOLOWER "${board_id}" board_id)

    set(core_lib_target_name "${board_id}_Core_Lib")

    set(${_return_var} ${core_lib_target_name} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Extracts a name symbol without possible file extension (marked usually by a dot ('.').
#       _input_string - String containing name symbol and possibly file extension.
#       _return_var - Name of a CMake variable that will hold the return value.
#       Returns - String containing input name without possible file extension.
#=============================================================================#
function(get_name_without_file_extension _input_string _return_var)

    get_property(name_we_regex GLOBAL PROPERTY ARDUINO_CMAKE_NAME_WE_REGEX_PATTERN)

    string(REGEX MATCH "${name_we_regex}" match "${_input_string}")

    set(${_return_var} ${CMAKE_MATCH_1} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Converts a given string to a PascalCase string, converting 1st letter to upper
# and remaining to lower.
#       _input_string - String to convert.
#       _return_var - Name of a CMake variable that will hold the return value.
#       Returns - PascalCase converted string.
#=============================================================================#
function(convert_string_to_pascal_case _input_string _return_var)

    # Convert 1st letter to upper case
    string(SUBSTRING ${_input_string} 0 1 first_letter)
    string(TOUPPER ${first_letter} first_letter_upper)

    # Convert remaining letters to lower case
    string(SUBSTRING ${_input_string} 1 -1 remaining_letters)
    string(TOLOWER ${remaining_letters} remaining_letters_lower)

    # Combine first letter with remaining letters
    string(APPEND combined_string ${first_letter_upper} ${remaining_letters_lower})

    set(${_return_var} ${combined_string} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Escapes a semicolon in a given string by replacing it with a "magic" string instead, 
# which isn't parsed as a list separator by CMake.
# This function can also reverse an escaped semicolon by replacing it back with a semicolon.
#       _string - String to escape/re-escape.
#       [REVERSE] - Optional flag indicating whether to reverse an already-escaped string back to its original form.
#       _return_var - Name of a CMake variable that will hold the return value.
#       Returns - Original string if [REVERSE] provided, Semicolon-escaped string otherwise.
#=============================================================================#
function(escape_semicolon_in_string _string _return_var)

    cmake_parse_arguments(parsed_args "REVERSE" "" "" ${ARGN})

    get_property(semicolon_replacement GLOBAL PROPERTY ARDUINO_CMAKE_SEMICOLON_REPLACEMENT)

    if (parsed_args_REVERSE)
        string(REGEX REPLACE "^(.+)${semicolon_replacement}(.*)$" "\\1;\\2" escaped_line "${_string}")
    else ()
        string(REGEX REPLACE "^(.+);(.*)$" "\\1${semicolon_replacement}\\2" escaped_line "${_string}")
    endif ()

    set(${_return_var} ${escaped_line} PARENT_SCOPE)

endfunction()
