# - Try to find opus include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(opus)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  opus_ROOT_DIR          Set this variable to the root installation of
#                            opus if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  opus_FOUND             System has opus, include and library dirs found
#  opus_INCLUDE_DIR       The opus include directories.
#  opus_LIBRARIES_STATIC  The opus libraries.
#  opus_LIBRARIES_SHARED  The opus libraries.

include(tearoot-helper)
include(FindPackageHandleStandardArgs)

function(resolve_opus)
	find_path(opus_ROOT_DIR
			NAMES include/opus/opus.h
			HINTS ${opus_ROOT_DIR} ${opus_ROOT_DIR}/${BUILD_OUTPUT}
	)

	find_path(opus_INCLUDE_DIR
			NAMES opus/opus.h opus/opus_defines.h
			HINTS ${opus_ROOT_DIR} ${opus_ROOT_DIR}/include/
	)

    if (NOT TARGET opus::static)
        find_library(opus_LIBRARIES_STATIC
                NAMES libopus.a opus.a opus.lib
                HINTS ${opus_ROOT_DIR} ${opus_ROOT_DIR}/lib
                )

        if(opus_LIBRARIES_STATIC)
            add_library(opus::static SHARED IMPORTED)
            set_target_properties(opus::static PROPERTIES
                    IMPORTED_LOCATION ${opus_LIBRARIES_STATIC}
                    INTERFACE_INCLUDE_DIRECTORIES ${opus_INCLUDE_DIR}
                    )
        endif()
    endif ()

    if (NOT TARGET opus::shared)
        find_library(opus_LIBRARIES_SHARED
                NAMES opus.dll libopus.so opus.so
                HINTS ${opus_ROOT_DIR} ${opus_ROOT_DIR}/lib
                )

        if(opus_LIBRARIES_SHARED)
            add_library(opus::shared SHARED IMPORTED)
            set_target_properties(opus::shared PROPERTIES
                    IMPORTED_LOCATION ${opus_LIBRARIES_SHARED}
                    INTERFACE_INCLUDE_DIRECTORIES ${opus_INCLUDE_DIR}
                    )
        endif()
    endif ()
	
	find_package_handle_standard_args(opus DEFAULT_MSG
			opus_INCLUDE_DIR
	)
endfunction()
resolve_opus()

