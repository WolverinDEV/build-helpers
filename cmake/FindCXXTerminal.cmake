# - Try to find CXXTerminal include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(CXXTerminal)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  CXXTerminal_ROOT_DIR          Set this variable to the root installation of
#                            CXXTerminal if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  CXXTerminal_FOUND             System has CXXTerminal, include and library dirs found
#  CXXTerminal_INCLUDE_DIR       The CXXTerminal include directories.
#  CXXTerminal_LIBRARIES_STATIC  The CXXTerminal libraries.
#  CXXTerminal_LIBRARIES_SHARED  The CXXTerminal libraries.

include(tearoot-helper)
include(FindPackageHandleStandardArgs)

find_path(CXXTerminal_ROOT_DIR
        NAMES include/CXXTerminal/Terminal.h
		HINTS ${CXXTerminal_ROOT_DIR}
)

find_path(CXXTerminal_INCLUDE_DIR
        NAMES CXXTerminal/Terminal.h
		HINTS ${CXXTerminal_ROOT_DIR} ${CXXTerminal_ROOT_DIR}/include/
)

if (NOT TARGET CXXTerminal::static)
    find_library(CXXTerminal_LIBRARIES_STATIC
            NAMES libCXXTerminalStatic.a
            HINTS ${CXXTerminal_ROOT_DIR} ${CXXTerminal_ROOT_DIR}/lib
            )

    if (CXXTerminal_LIBRARIES_STATIC)
        add_library(CXXTerminal::static SHARED IMPORTED)
        set_target_properties(CXXTerminal::static PROPERTIES
                IMPORTED_LOCATION ${CXXTerminal_LIBRARIES_STATIC}
                INTERFACE_INCLUDE_DIRECTORIES ${CXXTerminal_INCLUDE_DIR}
                )
    endif ()
endif ()

if (NOT TARGET CXXTerminal::shared)
    find_library(CXXTerminal_LIBRARIES_SHARED
            NAMES CXXTerminal.dll libCXXTerminal.so CXXTerminal.so
            HINTS ${CXXTerminal_ROOT_DIR} ${CXXTerminal_ROOT_DIR}/lib
            )

    if (CXXTerminal_LIBRARIES_SHARED)
        add_library(CXXTerminal::shared SHARED IMPORTED)
        set_target_properties(CXXTerminal::shared PROPERTIES
                IMPORTED_LOCATION ${CXXTerminal_LIBRARIES_SHARED}
                INTERFACE_INCLUDE_DIRECTORIES ${CXXTerminal_INCLUDE_DIR}
                )
    endif ()
endif ()

find_package_handle_standard_args(CXXTerminal DEFAULT_MSG
        CXXTerminal_INCLUDE_DIR
)

mark_as_advanced(
        CXXTerminal_ROOT_DIR
        CXXTerminal_INCLUDE_DIR
        CXXTerminal_LIBRARIES_STATIC
        CXXTerminal_LIBRARIES_SHARED
)