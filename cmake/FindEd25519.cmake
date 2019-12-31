# - Try to find ed25519 include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(ed25519)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  ed25519_ROOT_DIR          Set this variable to the root installation of
#                            ed25519 if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  ed25519_FOUND             System has ed25519, include and library dirs found
#  ed25519_INCLUDE_DIR       The ed25519 include directories.
#  ed25519_LIBRARIES_STATIC  The ed25519 libraries.
#  ed25519_LIBRARIES_SHARED  The ed25519 libraries.

include(tearoot-helper)
include(FindPackageHandleStandardArgs)

find_path(ed25519_ROOT_DIR
        NAMES include/ed25519/ed25519
		HINTS ${ed25519_ROOT_DIR} ${ed25519_ROOT_DIR}/${BUILD_OUTPUT}
)

find_path(ed25519_INCLUDE_DIR
        NAMES ed25519/ed25519.h
		HINTS ${ed25519_ROOT_DIR} ${ed25519_ROOT_DIR}/include/
)

find_library(ed25519_LIBRARIES_STATIC
        NAMES ed25519.lib ed25519.a libed25519.a
		HINTS ${ed25519_ROOT_DIR} ${ed25519_ROOT_DIR}/lib
)

find_library(ed25519_LIBRARIES_SHARED
        NAMES ed25519.dll ed25519.so
		HINTS ${ed25519_ROOT_DIR} ${ed25519_ROOT_DIR}/lib
)

find_package_handle_standard_args(ed25519 DEFAULT_MSG
        ed25519_INCLUDE_DIR
)

mark_as_advanced(
        ed25519_ROOT_DIR
        ed25519_INCLUDE_DIR
        ed25519_LIBRARIES_STATIC
        ed25519_LIBRARIES_SHARED
)