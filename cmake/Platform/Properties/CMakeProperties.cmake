#=============================================================================#
# Defines custom properties used internally by the framework.
#=============================================================================#
function(define_custom_properties)

    define_property(TARGET PROPERTY BOARD_ID
            BRIEF_DOCS "ID of the associated hardware board"
            FULL_DOCS
            "Framework-Internal ID of the hardware Arduino board associated with the target")

endfunction()
