#=============================================================================#
# Filters sources that relate to an architecture from the given list of unsupported architectures.
#       _unsupported_archs_regex - List of unsupported architectures as a regex-pattern string.
#       _sources - List of sources to check and potentially filter.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Filtered list of sources containing only those that don't relate to
#                 any unsupported architecture.
#=============================================================================#
function(_filter_unsupported_arch_sources _unsupported_archs_regex _sources _return_var)

    if (NOT "${_unsupported_archs_regex}" STREQUAL "") # Not all architectures are supported
        # Filter sources dependant on unsupported architectures
        list(FILTER _sources EXCLUDE REGEX ${_unsupported_archs_regex})
    endif ()

    set(${_return_var} ${_sources} PARENT_SCOPE)

endfunction()

#=============================================================================#
# Resolves library's architecture-related elements by doing several things:
# 1. Checking whether the platform's architecture is supported by the library
# 2. Filtering out any library sources that relate to unsupported architectures, i.e
#    architectures other than the platform's.
# If the platform's architecture isn't supported by the library, CMake generates an error and stops.
#       _library_sources - List of library's sources to check and potentially filter.
#       [LIB_PROPS_FILE] - Full path to the library's properties file. Optional.
#       _return_var - Name of variable in parent-scope holding the return value.
#       Returns - Filtered list of sources containing only those that don't relate to
#                 any unsupported architecture.
#=============================================================================#
function(resolve_library_architecture _library_sources _return_var)

    if(NOT _library_sources)
        return()
    endif()

    cmake_parse_arguments(parsed_args "" "LIB_PROPS_FILE" "" ${ARGN})

    if (parsed_args_LIB_PROPS_FILE) # Library properties file is given
        set(lib_props_file ${parsed_args_LIB_PROPS_FILE})
    else ()

        # Warn user and assume library is arch-agnostic
        message(STATUS "Library's properties file can't be found under its' root directory.\n\t"
                "Assuming the library is architecture-agnostic (supports all architectures)")
        set(${_return_var} "${_library_sources}" PARENT_SCOPE)
        return()

    endif ()

    get_arduino_library_supported_architectures("${lib_props_file}" lib_archs)

    # Check if the platform's architecture is supported by the library
    is_platform_architecture_supported(${lib_archs} arch_supported_by_lib)

    if (NOT ${arch_supported_by_lib})
        message(SEND_ERROR "The platform's architecture, ${ARDUINO_CMAKE_PLATFORM_ARCHITECTURE}, "
                "isn't supported by the ${_library_name} library")
    endif ()

    get_unsupported_architectures("${lib_archs}" unsupported_archs REGEX)

    # Filter any sources that aren't supported by the platform's architecture
    _filter_unsupported_arch_sources("${unsupported_archs}" "${_library_sources}" valid_sources)

    set(${_return_var} "${valid_sources}" PARENT_SCOPE)

endfunction()
