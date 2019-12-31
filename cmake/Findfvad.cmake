# - Try to find fvad include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(fvad)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  fvad_ROOT_DIR          Set this variable to the root installation of
#                            fvad if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  fvad_FOUND             System has fvad, include and library dirs found
#  fvad_INCLUDE_DIR       The fvad include directories.
#  fvad_LIBRARIES_STATIC  The fvad libraries.
#  fvad_LIBRARIES_SHARED  The fvad libraries.

include(tearoot-helper)
include(FindPackageHandleStandardArgs)

find_path(fvad_ROOT_DIR
        NAMES include/fvad.h
		HINTS ${fvad_ROOT_DIR} ${fvad_ROOT_DIR}/${BUILD_OUTPUT}
)

find_path(fvad_INCLUDE_DIR
        NAMES fvad.h
		HINTS ${fvad_ROOT_DIR} ${fvad_ROOT_DIR}/include/
)

find_library(fvad_LIBRARIES_STATIC
        NAMES fvad.lib libfvad.a libfvad.lib
		HINTS ${fvad_ROOT_DIR} ${fvad_ROOT_DIR}/lib
)

find_library(fvad_LIBRARIES_SHARED
        NAMES libfvad.dll libfvad.so
		HINTS ${fvad_ROOT_DIR} ${fvad_ROOT_DIR}/lib
)

find_package_handle_standard_args(fvad DEFAULT_MSG
        fvad_INCLUDE_DIR
)

mark_as_advanced(
        fvad_ROOT_DIR
        fvad_INCLUDE_DIR
        fvad_LIBRARIES_STATIC
        fvad_LIBRARIES_SHARED
)