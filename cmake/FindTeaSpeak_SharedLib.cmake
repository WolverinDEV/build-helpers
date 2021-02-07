# - Try to find TeaSpeak_SharedLib include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(TeaSpeak_SharedLib)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  TeaSpeak_SharedLib_ROOT_DIR          Set this variable to the root installation of
#                            TeaSpeak_SharedLib if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  TeaSpeak_SharedLib_FOUND             System has TeaSpeak_SharedLib, include and library dirs found
#  TeaSpeak_SharedLib_INCLUDE_DIR       The TeaSpeak_SharedLib include directories.
#  TeaSpeak_SharedLib_LIBRARIES_STATIC  The TeaSpeak_SharedLib libraries.
#  TeaSpeak_SharedLib_LIBRARIES_SHARED  The TeaSpeak_SharedLib libraries.

include(tearoot-helper)
include(FindPackageHandleStandardArgs)

find_path(TeaSpeak_SharedLib_OUT_DIR
        NAMES include/Definitions.h
        PATHS ${TeaSpeak_SharedLib_ROOT_DIR}/${BUILD_OUTPUT}/
)

if(TeaSpeak_SharedLib_OUT_DIR)
	find_library(TeaSpeak_SharedLib_LIBRARIES_STATIC
		NAMES libTeaSpeak.a TeaSpeak.a TeaSpeak.lib
		HINTS ${TeaSpeak_SharedLib_OUT_DIR}/lib
	)

	set(TeaSpeak_SharedLib_INCLUDE_DIR "${TeaSpeak_SharedLib_OUT_DIR}/include/")
	find_package_handle_standard_args(TeaSpeak_SharedLib DEFAULT_MSG
			TeaSpeak_SharedLib_INCLUDE_DIR
	)
else()
	message(WARNING "TeaSpeak shared lib release hasn't been build. Using development path.")

	find_path(TeaSpeak_SharedLib_ROOT_DIR
			NAMES src/Definitions.h CMakeLists.txt
			HINTS ${TeaSpeak_SharedLib_ROOT_DIR}
	)

	#This NEEDS a fix!
	find_path(TeaSpeak_SharedLib_INCLUDE_DIR
			NAMES Definitions.h
			HINTS ${TeaSpeak_SharedLib_ROOT_DIR}/src
	)

	find_library(TeaSpeak_SharedLib_LIBRARIES_STATIC
			NAMES libTeaSpeak.a TeaSpeak.a TeaSpeak.lib
			HINTS ${TeaSpeak_SharedLib_ROOT_DIR}/cmake-build-debug/ ${TeaSpeak_SharedLib_ROOT_DIR}/cmake-build-relwithdebinfo/
	)


	find_package_handle_standard_args(TeaSpeak_SharedLib DEFAULT_MSG
			TeaSpeak_SharedLib_INCLUDE_DIR
	)
endif()

mark_as_advanced(
        TeaSpeak_SharedLib_ROOT_DIR
        TeaSpeak_SharedLib_INCLUDE_DIR
        TeaSpeak_SharedLib_LIBRARIES_STATIC
)