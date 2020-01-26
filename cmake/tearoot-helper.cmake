macro(initialize_build_paths)
	if(NOT BUILD_OS_TYPE OR BUILD_OS_TYPE STREQUAL "")
		message(FATAL_ERROR "Missing os build type (BUILD_OS_TYPE). Please define it!")
	endif()
	if(NOT BUILD_OS_ARCH OR BUILD_OS_ARCH STREQUAL "")
		message(FATAL_ERROR "Missing os build arch (BUILD_OS_ARCH). Please define it!")
	endif()

	# Test for valid values
#	if(BUILD_OS_TYPE STREQUAL "win32")
#		if(BUILD_OS_ARCH STREQUAL "x86")
#			message(FATAL_ERROR "We currently not support windows x86")
#		elseif(BUILD_OS_ARCH STREQUAL "amd64")
#
#		else()
#			message(FATAL_ERROR "Invalid os build arch (${BUILD_OS_ARCH}). Supported OS archs are: amd64, x86")
#		endif()
#	elseif(BUILD_OS_TYPE STREQUAL "linux")
#		if(BUILD_OS_ARCH STREQUAL "x86")
#
#		elseif(BUILD_OS_ARCH STREQUAL "amd64")
#
#		else()
#			message(FATAL_ERROR "Invalid os build arch (${BUILD_OS_ARCH}). Supported OS archs are: amd64, x86")
#		endif()
#	else()
#		message(FATAL_ERROR "Invalid os build type (${BUILD_OS_TYPE}). Supported OS types are: linux, win32")
#	endif()

	if(NOT BUILD_OUTPUT OR BUILD_OUTPUT STREQUAL "")
		set(BUILD_OUTPUT "/out/${BUILD_OS_TYPE}_${BUILD_OS_ARCH}")
	endif()
endmacro()
initialize_build_paths()
