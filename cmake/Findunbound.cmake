# - Try to find unbound include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(unbound)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  unbound_ROOT_DIR          Set this variable to the root installation of
#                            unbound if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  unbound_FOUND             System has unbound, include and library dirs found
#  unbound_INCLUDE_DIR       The unbound include directories.
#  unbound_LIBRARIES_STATIC  The unbound libraries.
#  unbound_LIBRARIES_SHARED  The unbound libraries.

include(tearoot-helper)
include(FindPackageHandleStandardArgs)

function(resolve_unbound)
	find_path(unbound_ROOT_DIR
			NAMES include/unbound.h include/unbound-event.h
			HINTS ${unbound_ROOT_DIR} ${unbound_ROOT_DIR}/${BUILD_OUTPUT}
	)

	find_path(unbound_INCLUDE_DIR
			NAMES unbound.h unbound-event.h
			HINTS ${unbound_ROOT_DIR}/include/ ${unbound_ROOT_DIR}
	)
    message("Unbound include directory: ${unbound_INCLUDE_DIR}")

    if (NOT TARGET unbound::static)
        find_library(unbound_LIBRARIES_STATIC
                NAMES libunbound.a unbound.a unbound.lib
                HINTS ${unbound_ROOT_DIR} ${unbound_ROOT_DIR}/lib
        )

        if(unbound_LIBRARIES_STATIC)
            add_library(unbound::static STATIC IMPORTED)
            set_target_properties(unbound::static PROPERTIES
                    IMPORTED_LOCATION ${unbound_LIBRARIES_STATIC}
                    INTERFACE_INCLUDE_DIRECTORIES ${unbound_INCLUDE_DIR}
            )
        endif()
    endif()

    if (NOT TARGET unbound::shared)
        find_library(unbound_LIBRARIES_SHARED
                NAMES unbound.dll libunbound.so unbound.so
                HINTS ${unbound_ROOT_DIR} ${unbound_ROOT_DIR}/lib
                )

        if(unbound_LIBRARIES_SHARED)
            add_library(unbound::shared SHARED IMPORTED)
            set_target_properties(unbound::shared PROPERTIES
                    IMPORTED_LOCATION ${unbound_LIBRARIES_SHARED}
                    INTERFACE_INCLUDE_DIRECTORIES ${unbound_INCLUDE_DIR}
            )
        endif()
    endif ()
	
	find_package_handle_standard_args(unbound DEFAULT_MSG
			unbound_INCLUDE_DIR
	)
endfunction()
resolve_unbound()


