# - Try to find tomcrypt include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(TomCrypt)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  TomCrypt_ROOT_DIR          Set this variable to the root installation of
#                            TomCrypt if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  TomCrypt_FOUND             System has TomCrypt, include and library dirs found
#  TomCrypt_INCLUDE_DIR       The TomCrypt include directories.
#  TomCrypt_LIBRARIES_STATIC  The TomCrypt libraries.
#  TomCrypt_LIBRARIES_SHARED  The TomCrypt libraries.

include(tearoot-helper)
include(FindPackageHandleStandardArgs)

find_path(TomCrypt_ROOT_DIR
        NAMES include/tomcrypt.h
		HINTS ${TomCrypt_ROOT_DIR} ${TomCrypt_ROOT_DIR}/${BUILD_OUTPUT}
)

find_path(TomCrypt_INCLUDE_DIR
        NAMES tomcrypt.h tomcrypt_cfg.h
		HINTS ${TomCrypt_ROOT_DIR} ${TomCrypt_ROOT_DIR}/include/
)

if (NOT TARGET tomcrypt::static)
    find_library(TomCrypt_LIBRARIES_STATIC
            NAMES tomcrypt.lib libtomcrypt.lib libtomcrypt.a
            HINTS ${TomCrypt_ROOT_DIR} ${TomCrypt_ROOT_DIR}/lib
            )

    if (TomMath_LIBRARIES_STATIC)
        add_library(tomcrypt::static SHARED IMPORTED)
        set_target_properties(tomcrypt::static PROPERTIES
                IMPORTED_LOCATION ${TomCrypt_LIBRARIES_STATIC}
                INTERFACE_INCLUDE_DIRECTORIES ${TomCrypt_INCLUDE_DIR}
                )
    endif ()
endif ()

if (NOT TARGET tomcrypt::shared)
    find_library(TomCrypt_LIBRARIES_SHARED
            NAMES tomcrypt.dll libtomcrypt.dll libtomcrypt.so
            HINTS ${TomCrypt_ROOT_DIR} ${TomCrypt_ROOT_DIR}/lib
            )

    if (TomCrypt_LIBRARIES_SHARED)
        add_library(tomcrypt::static SHARED IMPORTED)
        set_target_properties(tomcrypt::shared PROPERTIES
                IMPORTED_LOCATION ${TomCrypt_LIBRARIES_SHARED}
                INTERFACE_INCLUDE_DIRECTORIES ${TomCrypt_INCLUDE_DIR}
                )
    endif ()
endif ()

find_package_handle_standard_args(TomCrypt DEFAULT_MSG
        TomCrypt_INCLUDE_DIR
)

mark_as_advanced(
        TomCrypt_ROOT_DIR
        TomCrypt_INCLUDE_DIR
        TomCrypt_LIBRARIES_STATIC
        TomCrypt_LIBRARIES_SHARED
)