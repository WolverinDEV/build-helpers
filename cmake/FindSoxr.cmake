# - Try to find soxr include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(soxr)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  soxr_ROOT_DIR          Set this variable to the root installation of
#                            soxr if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  soxr_FOUND             System has soxr, include and library dirs found
#  soxr_INCLUDE_DIR       The soxr include directories.
#  soxr_LIBRARIES_STATIC  The soxr libraries.
#  soxr_LIBRARIES_SHARED  The soxr libraries.

include(tearoot-helper)
include(FindPackageHandleStandardArgs)

find_path(soxr_ROOT_DIR
        NAMES include/soxr.h
		HINTS ${soxr_ROOT_DIR} ${soxr_ROOT_DIR}/${BUILD_OUTPUT}
)

find_path(soxr_INCLUDE_DIR
        NAMES soxr.h
		HINTS ${soxr_ROOT_DIR} ${soxr_ROOT_DIR}/include/
)

find_library(soxr_LIBRARIES_STATIC
        NAMES libsoxr.a soxr.a soxr.lib
		HINTS ${soxr_ROOT_DIR} ${soxr_ROOT_DIR}/lib
)

find_library(soxr_LIBRARIES_SHARED
        NAMES soxr.dll libsoxr.so soxr.so
		HINTS ${soxr_ROOT_DIR} ${soxr_ROOT_DIR}/lib
)

find_package_handle_standard_args(soxr DEFAULT_MSG
        soxr_INCLUDE_DIR
)

mark_as_advanced(
        soxr_ROOT_DIR
        soxr_INCLUDE_DIR
        soxr_LIBRARIES_STATIC
        soxr_LIBRARIES_SHARED
)