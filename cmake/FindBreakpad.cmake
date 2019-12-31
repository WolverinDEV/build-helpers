# - Try to find breakpad include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(breakpad)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  breakpad_ROOT_DIR          Set this variable to the root installation of
#                            breakpad if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  breakpad_FOUND             System has breakpad, include and library dirs found
#  breakpad_INCLUDE_DIR       The breakpad include directories.
#  breakpad_SOURCE_FILES      The source files which have to be included.
#  breakpad_HEADER_FIOLES     Header files which might be included.


include(tearoot-helper)
include(FindPackageHandleStandardArgs)

find_path(breakpad_ROOT_DIR
        NAMES include/breakpad/client/minidump_file_writer.h include/breakpad/common/language.h
        HINTS ${breakpad_ROOT_DIR}
)

find_path(breakpad_INCLUDE_DIR
        NAMES breakpad/client/minidump_file_writer.h breakpad/common/language.h
        HINTS ${breakpad_ROOT_DIR} ${breakpad_ROOT_DIR}/inclue/
)

set(breakpad_SOURCE_FILES "")
set(breakpad_HEADER_FIOLES "")

#https://blog.inventic.eu/2012/08/qt-and-google-breakpad/
if(WIN32)
	set(breakpad_SOURCE_FILES ${breakpad_SOURCE_FILES}
		${breakpad_ROOT_DIR}/src/client/windows/handler/exception_handler.cc
		${breakpad_ROOT_DIR}/src/common/windows/string_utils.cc
		${breakpad_ROOT_DIR}/src/common/windows/guid_string.cc
		${breakpad_ROOT_DIR}/src/client/windows/crash_generation/crash_generation_client.cc 
	)
	set(breakpad_HEADER_FIOLES ${breakpad_HEADER_FIOLES}
		${breakpad_ROOT_DIR}/src/common/windows/string_utils-inl.h
		${breakpad_ROOT_DIR}/src/common/windows/guid_string.h
		${breakpad_ROOT_DIR}/src/client/windows/handler/exception_handler.h
		${breakpad_ROOT_DIR}/src/client/windows/common/ipc_protocol.h
		${breakpad_ROOT_DIR}/src/google_breakpad/common/minidump_format.h 
		${breakpad_ROOT_DIR}/src/google_breakpad/common/breakpad_types.h 
		${breakpad_ROOT_DIR}/src/client/windows/crash_generation/crash_generation_client.h 
		${breakpad_ROOT_DIR}/src/processor/scoped_ptr.h
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
				INTERFACE_INCLUDE_DIRECTORIES ${Breakpad_INCLUDE_DIR}
				INTERFACE_INCLUDE_DIRECTORIES ${Breakpad_INCLUDE_DIR}/breakpad
		)
	endif ()
	message("Breakpad: ${Breakpad_INCLUDE_DIR}")
endif()

find_package_handle_standard_args(breakpad DEFAULT_MSG
        breakpad_INCLUDE_DIR
)

mark_as_advanced(
        breakpad_ROOT_DIR
        breakpad_INCLUDE_DIR
        breakpad_SOURCE_FILES
		breakpad_HEADER_FIOLES
)