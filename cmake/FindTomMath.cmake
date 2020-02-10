# - Try to find tommath include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(TomMath)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  TomMath_ROOT_DIR          Set this variable to the root installation of
#                            TomMath if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  TomMath_FOUND             System has TomMath, include and library dirs found
#  TomMath_INCLUDE_DIR       The TomMath include directories.
#  TomMath_LIBRARIES_STATIC  The TomMath libraries.
#  TomMath_LIBRARIES_SHARED  The TomMath libraries.

include(tearoot-helper)
include(FindPackageHandleStandardArgs)

message("Tommath root dir: ${TomMath_ROOT_DIR}")
find_path(TomMath_INCLUDE_DIR
        NAMES tommath.h tommath_private.h
		HINTS ${TomMath_ROOT_DIR}/ ${TomMath_ROOT_DIR}/include/
)

if (NOT TARGET tommath::static)
    find_library(TomMath_LIBRARIES_STATIC
            NAMES tommathStatic.lib tommath.lib tommath.a libtommath.a libtommathStatic.a
            HINTS ${TomMath_ROOT_DIR} ${TomMath_ROOT_DIR}/${BUILD_OUTPUT} ${TomMath_ROOT_DIR}/lib
            )

    if (TomMath_LIBRARIES_STATIC)
        add_library(tommath::static STATIC IMPORTED)
        set_target_properties(tommath::static PROPERTIES
                IMPORTED_LOCATION ${TomMath_LIBRARIES_STATIC}
                INTERFACE_INCLUDE_DIRECTORIES ${TomMath_INCLUDE_DIR}
                )
    endif ()
endif ()

if (NOT TARGET tommath::shared)
    find_library(TomMath_LIBRARIES_SHARED
            NAMES tommath.dll libtommath.so tommath.so libtommathShared.so
            HINTS ${TomMath_ROOT_DIR} ${TomMath_ROOT_DIR}/${BUILD_OUTPUT} ${TomMath_ROOT_DIR} ${TomMath_ROOT_DIR}/lib
            )

    if (TomMath_LIBRARIES_SHARED)
        add_library(tommath::shared SHARED IMPORTED)
        set_target_properties(tommath::shared PROPERTIES
                IMPORTED_LOCATION ${TomMath_LIBRARIES_SHARED}
                INTERFACE_INCLUDE_DIRECTORIES ${TomMath_INCLUDE_DIR}
                )
    endif ()
endif ()

find_package_handle_standard_args(TomMath DEFAULT_MSG
        TomMath_INCLUDE_DIR
)

mark_as_advanced(
        TomMath_ROOT_DIR
        TomMath_INCLUDE_DIR
        TomMath_LIBRARIES_STATIC
        TomMath_LIBRARIES_SHARED
)
