# - Try to find soundio include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(soundio)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  soundio_ROOT_DIR          Set this variable to the root installation of
#                            soundio if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  soundio_FOUND             System has soundio, include and library dirs found
#  soundio_INCLUDE_DIR       The soundio include directories.
#  soundio_LIBRARIES_STATIC  The soundio libraries.
#  soundio_LIBRARIES_SHARED  The soundio libraries.

include(tearoot-helper)
include(FindPackageHandleStandardArgs)

find_path(soundio_ROOT_DIR
        NAMES include/soundio/soundio.h
		HINTS ${soundio_ROOT_DIR}
)

find_path(soundio_INCLUDE_DIR
        NAMES soundio/soundio.h
		HINTS ${soundio_ROOT_DIR} ${soundio_ROOT_DIR}/include/
)

if (NOT TARGET soundio::static)
    find_library(soundio_LIBRARIES_STATIC
            NAMES libsoundio.a soundio.lib
            HINTS ${soundio_ROOT_DIR} ${soundio_ROOT_DIR}/lib
    )

    if (soundio_LIBRARIES_STATIC)
        add_library(soundio::static STATIC IMPORTED)
        set_target_properties(soundio::static PROPERTIES
                IMPORTED_LOCATION ${soundio_LIBRARIES_STATIC}
                INTERFACE_INCLUDE_DIRECTORIES ${soundio_INCLUDE_DIR}
        )
    endif ()
endif ()

if (NOT TARGET soundio::shared)
    find_library(soundio_LIBRARIES_SHARED
            NAMES soundio.dll libsoundio.so
            HINTS ${soundio_ROOT_DIR} ${soundio_ROOT_DIR}/lib
    )

    if (soundio_LIBRARIES_SHARED)
        add_library(soundio::shared SHARED IMPORTED)
        set_target_properties(soundio::shared PROPERTIES
                IMPORTED_LOCATION ${soundio_LIBRARIES_SHARED}
                INTERFACE_INCLUDE_DIRECTORIES ${soundio_INCLUDE_DIR}
        )
    endif ()
endif ()

find_package_handle_standard_args(soundio DEFAULT_MSG
        soundio_INCLUDE_DIR
)

mark_as_advanced(
        soundio_ROOT_DIR
        soundio_INCLUDE_DIR
        soundio_LIBRARIES_STATIC
        soundio_LIBRARIES_SHARED
)
