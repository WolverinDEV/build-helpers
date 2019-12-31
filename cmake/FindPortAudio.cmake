# - Try to find PortAudio include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(PortAudio)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  PortAudio_ROOT_DIR          Set this variable to the root installation of
#                            PortAudio if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  PortAudio_FOUND             System has PortAudio, include and library dirs found
#  PortAudio_INCLUDE_DIR       The PortAudio include directories.
#  PortAudio_LIBRARIES_STATIC  The PortAudio libraries.
#  PortAudio_LIBRARIES_SHARED  The PortAudio libraries.

include(tearoot-helper)
include(FindPackageHandleStandardArgs)

find_path(PortAudio_ROOT_DIR
        NAMES include/portaudio.h
		HINTS ${PortAudio_ROOT_DIR} ${PortAudio_ROOT_DIR}/${BUILD_OUTPUT}
)

find_path(PortAudio_INCLUDE_DIR
        NAMES portaudio.h
		HINTS ${PortAudio_ROOT_DIR} ${PortAudio_ROOT_DIR}/include/
)

find_library(PortAudio_LIBRARIES_STATIC
        NAMES libportaudio.a libportaudio_static.a portaudio_static_x64.a portaudio_static_x64.lib
		HINTS ${PortAudio_ROOT_DIR} ${PortAudio_ROOT_DIR}/lib
)

find_library(PortAudio_LIBRARIES_SHARED
        NAMES libportaudio.so portaudio_shared_x64.dll portaudio_shared_x64.so
		HINTS ${PortAudio_ROOT_DIR} ${PortAudio_ROOT_DIR}/lib
)

find_package_handle_standard_args(PortAudio DEFAULT_MSG
        PortAudio_INCLUDE_DIR
)

mark_as_advanced(
        PortAudio_ROOT_DIR
        PortAudio_INCLUDE_DIR
        PortAudio_LIBRARIES_STATIC
        PortAudio_LIBRARIES_SHARED
)
