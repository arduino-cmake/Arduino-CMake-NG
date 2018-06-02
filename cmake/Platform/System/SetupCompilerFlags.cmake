# Setup C compiler flags
if (NOT DEFINED ARDUINO_CMAKE_C_FLAGS)
    set(ARDUINO_CMAKE_C_FLAGS "-mcall-prologues" "-ffunction-sections" "-fdata-sections"
            CACHE STRING "Arduino-specific C compiler flags")
endif ()

# Setup CXX (C++) compiler flags
if (NOT DEFINED ARDUINO_CMAKE_CXX_FLAGS)
    set(ARDUINO_CMAKE_CXX_FLAGS "${ARDUINO_CMAKE_C_FLAGS}" "-fno-exceptions"
            CACHE STRING "Arduino-specific C++ compiler flags")
endif ()

if (${USE_ARDUINO_CMAKE_COMPILER_FLAGS})
    add_compile_options(${ARDUINO_CMAKE_CXX_FLAGS})
endif ()
