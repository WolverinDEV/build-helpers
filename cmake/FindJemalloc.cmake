# - Try to find Jemalloc include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(Jemalloc)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  Jemalloc_ROOT_DIR          Set this variable to the root installation of
#                            Jemalloc if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  Jemalloc_FOUND             System has Jemalloc, include and library dirs found
#  Jemalloc_INCLUDE_DIR       The Jemalloc include directories.
#  Jemalloc_LIBRARIES_STATIC  The Jemalloc libraries.
#  Jemalloc_LIBRARIES_SHARED  The Jemalloc libraries.

include(tearoot-helper)
include(FindPackageHandleStandardArgs)

function(resolve_Jemalloc)
	find_path(Jemalloc_ROOT_DIR
			NAMES include/jemalloc/jemalloc.h
			HINTS ${Jemalloc_ROOT_DIR} ${Jemalloc_ROOT_DIR}/${BUILD_OUTPUT}
	)

	find_path(Jemalloc_INCLUDE_DIR
			NAMES jemalloc/jemalloc.h
			HINTS ${Jemalloc_ROOT_DIR} ${Jemalloc_ROOT_DIR}/include/
	)

    if (NOT TARGET jemalloc::shared)
        find_library(Jemalloc_LIBRARIES_SHARED
                NAMES libjemalloc.so jemalloc.dll
                HINTS ${Jemalloc_ROOT_DIR} ${Jemalloc_ROOT_DIR}/lib
        )

        if(Jemalloc_LIBRARIES_SHARED)
            add_library(jemalloc::shared SHARED IMPORTED)
            set_target_properties(jemalloc::shared PROPERTIES
                IMPORTED_LOCATION ${Jemalloc_LIBRARIES_SHARED}
                INTERFACE_INCLUDE_DIRECTORIES ${Jemalloc_INCLUDE_DIR}
            )
        endif()
    endif ()
	
	find_package_handle_standard_args(Jemalloc DEFAULT_MSG
			Jemalloc_INCLUDE_DIR
	)
endfunction()
resolve_Jemalloc()

