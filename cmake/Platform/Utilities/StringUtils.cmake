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
