include(SetDefaults)
include(FindAVRTools)
include(VersionDetector)

detect_sdk_version()
set_source_files_pattern()

include(InitializePlatform)
