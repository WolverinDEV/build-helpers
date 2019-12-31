# - Try to find StringVariable include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(StringVariable)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  StringVariable_ROOT_DIR          Set this variable to the root installation of
#                            StringVariable if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  StringVariable_FOUND             System has StringVariable, include and library dirs found
#  StringVariable_INCLUDE_DIR       The StringVariable include directories.
#  StringVariable_LIBRARIES_STATIC  The StringVariable libraries.
#  StringVariable_LIBRARIES_SHARED  The StringVariable libraries.

include(tearoot-helper)
include(FindPackageHandleStandardArgs)

find_path(StringVariable_ROOT_DIR
        NAMES include/StringVariable.h CMakeLists.txt
		HINTS ${StringVariable_ROOT_DIR} ${StringVariable_ROOT_DIR}/${BUILD_OUTPUT}
)

find_path(StringVariable_INCLUDE_DIR
        NAMES StringVariable.h
		HINTS ${StringVariable_ROOT_DIR} ${StringVariable_ROOT_DIR}/include/
)

find_library(StringVariable_LIBRARIES_STATIC
        NAMES StringVariablesStatic.lib libStringVariablesStatic.a StringVariablesStatic.a
		HINTS ${StringVariable_ROOT_DIR} ${StringVariable_ROOT_DIR}/lib
)

find_library(StringVariable_LIBRARIES_SHARED
        NAMES StringVariable.dll libStringVariable.so StringVariable.so
		HINTS ${StringVariable_ROOT_DIR} ${StringVariable_ROOT_DIR}/lib
)

find_package_handle_standard_args(StringVariable DEFAULT_MSG
        StringVariable_INCLUDE_DIR
)

mark_as_advanced(
        StringVariable_ROOT_DIR
        StringVariable_INCLUDE_DIR
        StringVariable_LIBRARIES_STATIC
        StringVariable_LIBRARIES_SHARED
)