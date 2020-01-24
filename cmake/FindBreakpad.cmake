# - Try to find breakpad include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(breakpad)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  Breakpad_ROOT_DIR          Set this variable to the root installation of
#                            breakpad if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  Breakpad_FOUND             System has breakpad, include and library dirs found
#  Breakpad_INCLUDE_DIR       The breakpad include directories.
#  Breakpad_SOURCE_FILES      The source files which have to be included.
#  Breakpad_HEADER_FIOLES     Header files which might be included.


include(tearoot-helper)
include(FindPackageHandleStandardArgs)

find_path(Breakpad_ROOT_DIR
        NAMES include/breakpad/client/linux/handler/exception_handler.h
        HINTS ${Breakpad_ROOT_DIR}
)

find_path(Breakpad_INCLUDE_DIR
        NAMES breakpad/client/linux/handler/exception_handler.h
        HINTS ${Breakpad_ROOT_DIR} ${Breakpad_ROOT_DIR}/include/
)

set(Breakpad_SOURCE_FILES "")
set(Breakpad_HEADER_FIOLES "")

#https://blog.inventic.eu/2012/08/qt-and-google-breakpad/
if(WIN32)
	set(Breakpad_SOURCE_FILES ${Breakpad_SOURCE_FILES}
		${Breakpad_ROOT_DIR}/src/client/windows/handler/exception_handler.cc
		${Breakpad_ROOT_DIR}/src/common/windows/string_utils.cc
		${Breakpad_ROOT_DIR}/src/common/windows/guid_string.cc
		${Breakpad_ROOT_DIR}/src/client/windows/crash_generation/crash_generation_client.cc
	)
	set(Breakpad_HEADER_FIOLES ${Breakpad_HEADER_FIOLES}
		${Breakpad_ROOT_DIR}/src/common/windows/string_utils-inl.h
		${Breakpad_ROOT_DIR}/src/common/windows/guid_string.h
		${Breakpad_ROOT_DIR}/src/client/windows/handler/exception_handler.h
		${Breakpad_ROOT_DIR}/src/client/windows/common/ipc_protocol.h
		${Breakpad_ROOT_DIR}/src/google_breakpad/common/minidump_format.h
		${Breakpad_ROOT_DIR}/src/google_breakpad/common/breakpad_types.h
		${Breakpad_ROOT_DIR}/src/client/windows/crash_generation/crash_generation_client.h
		${Breakpad_ROOT_DIR}/src/processor/scoped_ptr.h
	)
else()
	find_path(Breakpad_ROOT_DIR
			NAMES include/breakpad/client/linux/handler/exception_handler.h
			HINTS ${Breakpad_ROOT_DIR}
	)

	find_path(Breakpad_INCLUDE_DIR
			NAMES breakpad/client/linux/handler/exception_handler.h
			HINTS ${Breakpad_ROOT_DIR} ${Breakpad_ROOT_DIR}/include/
	)

	find_library(Breakpad_LIBRARIES_STATIC
			NAMES libbreakpad_client.a
			HINTS ${Breakpad_ROOT_DIR} ${Breakpad_ROOT_DIR}/lib
	)

	if (Breakpad_LIBRARIES_STATIC)
		add_library(breakpad::static SHARED IMPORTED)
		set_target_properties(breakpad::static PROPERTIES
				IMPORTED_LOCATION ${Breakpad_LIBRARIES_STATIC}
				INTERFACE_INCLUDE_DIRECTORIES "${Breakpad_INCLUDE_DIR};${Breakpad_INCLUDE_DIR}/breakpad"
		)
	endif ()
	message("Breakpad: ${Breakpad_INCLUDE_DIR}")
endif()

find_package_handle_standard_args(Breakpad DEFAULT_MSG
        Breakpad_INCLUDE_DIR
)

mark_as_advanced(
        Breakpad_ROOT_DIR
        Breakpad_INCLUDE_DIR
        Breakpad_SOURCE_FILES
		Breakpad_HEADER_FIOLES
)