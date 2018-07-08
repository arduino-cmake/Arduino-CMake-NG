cmake_minimum_required(VERSION 3.8)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Utilities)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/System)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Other)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Targets)

include(MathUtils)
include(ListUtils)
include(StringUtils)
include(PropertyUtils)

include(BoardManager)
include(RecipeParser)
include(TargetFlagsManager)
include(SourceFileManager)
include(DefaultsManager)

include(BuildSystemInitializer)

include(ExecutableTarget)
include(UploadTarget)
include(CoreLibTarget)
include(ArduinoCMakeLibraryTarget)
include(ArduinoLibraryTarget)
include(PlatformLibraryTarget)

initialize_build_system()
