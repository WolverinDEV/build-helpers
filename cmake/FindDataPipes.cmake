# - Try to find DataPipes include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(DataPipes)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  DataPipes_ROOT_DIR          Set this variable to the root installation of
#                            DataPipes if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  DataPipes_FOUND             System has DataPipes, include and library dirs found
#  DataPipes_INCLUDE_DIR       The DataPipes include directories.
#  DataPipes_LIBRARIES_STATIC  The DataPipes libraries.
#  DataPipes_LIBRARIES_SHARED  The DataPipes libraries.

include(tearoot-helper)
include(FindPackageHandleStandardArgs)

find_path(DataPipes_ROOT_DIR
        NAMES include/pipes/buffer.h include/pipes/pipeline.h
        HINTS ${DataPipes_ROOT_DIR}
)

find_path(DataPipes_INCLUDE_DIR
        NAMES pipes/pipeline.h pipes/buffer.h
        HINTS ${DataPipes_ROOT_DIR}/include/
)

if (NOT TARGET DataPipes::static)
    find_library(DataPipes_LIBRARIES_STATIC
            NAMES DataPipes.lib libDataPipes.a
            HINTS ${DataPipes_ROOT_DIR} ${DataPipes_ROOT_DIR}/lib
            )

    if(DataPipes_LIBRARIES_STATIC)
        add_library(DataPipes::static STATIC IMPORTED)
        set_target_properties(DataPipes::static PROPERTIES
                IMPORTED_LOCATION ${DataPipes_LIBRARIES_STATIC}
                INTERFACE_INCLUDE_DIRECTORIES ${DataPipes_INCLUDE_DIR}
                )
    endif()
endif ()

if (NOT TARGET DataPipes::shared)
    find_library(DataPipes_LIBRARIES_SHARED
            NAMES DataPipes.dll libDataPipes.so
            HINTS ${DataPipes_ROOT_DIR} ${DataPipes_ROOT_DIR}/lib
            )

    if(DataPipes_LIBRARIES_SHARED)
        add_library(DataPipes::shared SHARED IMPORTED)
        set_target_properties(DataPipes::shared PROPERTIES
                IMPORTED_LOCATION ${DataPipes_LIBRARIES_SHARED}
                INTERFACE_INCLUDE_DIRECTORIES ${DataPipes_INCLUDE_DIR}
                )
    endif()
endif ()

find_package_handle_standard_args(DataPipes DEFAULT_MSG
        DataPipes_INCLUDE_DIR
)

mark_as_advanced(
        DataPipes_ROOT_DIR
        DataPipes_INCLUDE_DIR
        DataPipes_LIBRARIES_STATIC
        DataPipes_LIBRARIES_SHARED
)