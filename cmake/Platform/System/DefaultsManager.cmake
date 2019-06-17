#=============================================================================#
# Sets search patterns used internaly by the framework for searching purposes.
#=============================================================================#
function(set_internal_search_patterns)

    set_property(GLOBAL PROPERTY ARDUINO_CMAKE_SEMICOLON_REPLACEMENT "!@&#%")

    set_property(GLOBAL PROPERTY ARDUINO_CMAKE_PREPROCESSOR_REGEX_PATTERN "^#([A-Za-z0-9_])+")
    set(header_include_regex "^#include.*[<\"]")
    set_property(GLOBAL PROPERTY ARDUINO_CMAKE_HEADER_INCLUDE_REGEX_PATTERN "${header_include_regex}")

    set_property(GLOBAL PROPERTY ARDUINO_CMAKE_HEADER_NAME_REGEX_PATTERN "${header_include_regex}(.+)[>\"]$")
    set_property(GLOBAL PROPERTY ARDUINO_CMAKE_HEADER_FILE_EXTENSION_REGEX_PATTERN ".+\\.h.*$")
    set_property(GLOBAL PROPERTY ARDUINO_CMAKE_NAME_WE_REGEX_PATTERN "([^\\/]+)\\.")

    set_property(GLOBAL PROPERTY ARDUINO_CMAKE_FUNCTION_DEFINITION_REGEX_PATTERN
            "^([A-Za-z0-9_][ \t\r\n]*)+\\(.*\\)[ \t\r\n]*[{]*$")
    set_property(GLOBAL PROPERTY ARDUINO_CMAKE_FUNCTION_DECLARATION_REGEX_PATTERN
            "^([A-Za-z0-9_])+.+([A-Za-z0-9_])+[ \t\r\n]*\\((.*)\\);$")

    set_property(GLOBAL PROPERTY ARDUINO_CMAKE_FUNCTION_NAME_REGEX_PATTERN "(([A-Za-z0-9_])+)[ \t\r\n]*\\(.*\\)")
    set_property(GLOBAL PROPERTY ARDUINO_CMAKE_FUNCTION_ARGS_REGEX_PATTERN "\\((.*)\\)")
    set_property(GLOBAL PROPERTY ARDUINO_CMAKE_FUNCTION_SINGLE_ARG_REGEX_PATTERN "([A-Za-z0-9_]+)[^,]*")
    set_property(GLOBAL PROPERTY ARDUINO_CMAKE_FUNCTION_ARG_TYPE_REGEX_PATTERN "[A-Za-z0-9_]+.*[ \t\r\n]+")

endfunction()

#=============================================================================#
# Sets globb patterns for various types of source files, used mostly for searching purposes.
#=============================================================================#
function(set_source_files_patterns)

    set(ARDUINO_CMAKE_SOURCE_FILES_PATTERN *.c *.cc *.cpp *.cxx *.[Ss] CACHE STRING
            "Source Files Pattern")
    set(ARDUINO_CMAKE_HEADER_FILES_PATTERN *.h *.hh *.hpp *.hxx CACHE STRING
            "Header Files Pattern")
    set(ARDUINO_CMAKE_SKETCH_FILES_PATTERN *.ino *.pde CACHE STRING
            "Sketch Files Pattern")

endfunction()

#=============================================================================#
# Sets various options specific for the Arduino-CMake framework.
#=============================================================================#
function(set_default_arduino_cmake_options)

    option(USE_DEFAULT_PLATFORM_IF_NONE_EXISTING
            "Whether to use Arduino as default platform if none is supplied"
            ON)
    option(USE_CUSTOM_PLATFORM_HEADER
            "Whether to expect and use a custom-supplied platform header, \
            skipping the selection algorithm"
            OFF)
    option(USE_ARCHLINUX_BUILTIN_SUPPORT
            "Whether to use Arduino CMake's built-in support for the archlinux distribution"
            ON)
    option(CONVERT_SKETCHES_IF_CONVERTED_SOURCES_EXISTS
            "Whether to convert sketches to source files even if converted sources already exist"
            OFF)
    option(AUTO_SET_SKETCHBOOK_PATH
            "Whether Arduino IDE's Sketchbook Location should be automatically found"
            OFF)

endfunction()

#=============================================================================#
# Sets default paths used by the framework
#=============================================================================#
function(set_default_paths)

    set(ARDUINO_CMAKE_LIBRARY_PROPERTIES_FILE_NAME "library.properties" CACHE STRING
            "Name of the libraries' properties file")

endfunction()

#=============================================================================#
# Sets various defaults used throughout the platform.
#=============================================================================#
function(set_arduino_cmake_defaults)

    set_internal_search_patterns()
    set_source_files_patterns()
    set_default_arduino_cmake_options()
    set_default_paths()

endfunction()
