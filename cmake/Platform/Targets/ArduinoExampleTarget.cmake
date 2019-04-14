#=============================================================================#
# Adds/Creates an Arduino-Example executable target with the given name,
# using the given board ID and example's sources.
#       _target_name - Name of the target (Executable) to create.
#       _example_name - Name of the example to use, such as 'Blink'.
#       [CATEGORY cat] - Optional argument representing the category of the Example to use.
#                        e.g The 'Blink' example is under the '01.Basics' category.
#                        Generally, all this does is improving search performance by narrowing.
#=============================================================================#
function(add_arduino_example _target_name _example_name)

    convert_string_to_pascal_case(${_example_name} arduino_compliant_example_name)

    find_arduino_example_sources("${ARDUINO_SDK_EXAMPLES_PATH}"
            ${arduino_compliant_example_name} example_sketches ${ARGN})

    # First create the target (Without sources), then add sketches as converted sources
    add_arduino_executable(${_target_name})

    target_sketches(${_target_name} "${example_sketches}")

endfunction()

#=============================================================================#
# Adds/Creates an Arduino-Library-Example executable target with the given name,
# using the given board ID and library example's sources.
#       _target_name - Name of the target (Executable) to create.
#       _library_target_name - Name of an already-existing library target.
#                              This means the library should first be found by the user.
#       _library_name - Name of the library the example belongs to, such as 'Servo'.
#       _example_name - Name of the example to use, such as 'Knob'.
#       [CATEGORY cat] - Optional argument representing the category of the Example to use.
#                        e.g The 'Blink' example is under the '01.Basics' category.
#                        Generally, all this does is improving search performance by narrowing.
#=============================================================================#
function(add_arduino_library_example _target_name _library_target_name _library_name _example_name)

    convert_string_to_pascal_case(${_example_name} arduino_compliant_example_name)
    convert_string_to_pascal_case(${_library_name} arduino_compliant_library_name)

    if (NOT TARGET ${_library_target_name})
        message(SEND_ERROR "Library target doesn't exist - It must be created first!")
    endif ()

    find_file(library_path
            NAMES ${arduino_compliant_library_name}
            PATHS ${ARDUINO_CMAKE_PLATFORM_LIBRARIES_PATH} ${ARDUINO_SDK_LIBRARIES_PATH}
            ${ARDUINO_CMAKE_SKETCHBOOK_PATH} ${CMAKE_CURRENT_SOURCE_DIR} ${PROJECT_SOURCE_DIR}
            PATH_SUFFIXES libraries dependencies
            NO_DEFAULT_PATH
            NO_CMAKE_FIND_ROOT_PATH)

    find_arduino_library_example_sources("${library_path}"
            ${arduino_compliant_example_name} example_sketches ${ARGN})

    add_arduino_executable(${_target_name})

    target_sketches(${_target_name} "${example_sketches}")

    link_arduino_library(${_target_name} ${_library_target_name})

endfunction()