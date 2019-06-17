cmake_minimum_required(VERSION 3.8.2)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Utilities)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Hardware/Boards)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/System)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Other)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Project)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Properties)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Sketches)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Sources)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Libraries)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Targets)

include(Utilities)

include(Boards)

include(RecipeParser)
include(TargetFlagsManager)

include(Sources)
include(Sketches)

include(DefaultsManager)
include(ArchitectureSupportQuery)
include(CMakeProperties)

include(Libraries)

include(BuildSystemInitializer)

include(ExecutableTarget)
include(UploadTarget)
include(CoreLibTarget)
include(ArduinoCMakeLibraryTarget)
include(ArduinoLibraryTarget)
include(PlatformLibraryTarget)
include(ArduinoExampleTarget)

include(Project)

initialize_build_system()
