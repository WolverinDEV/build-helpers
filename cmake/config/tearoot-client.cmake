if (WIN32)
	set(BUILD_OS_TYPE "win32")
	set(BUILD_OS_ARCH "amd64")
else()
	set(BUILD_OS_TYPE "linux")
	set(BUILD_OS_ARCH "amd64")
endif ()

if(NOT LIBRARY_PATH OR LIBRARY_PATH STREQUAL "")
	message(FATAL_ERROR "Missing library path")
endif()

include(tearoot-helper)
SET(TomMath_ROOT_DIR "${LIBRARY_PATH}/tommath/${BUILD_OUTPUT}")
SET(TomCrypt_ROOT_DIR "${LIBRARY_PATH}/tomcrypt/${BUILD_OUTPUT}")
SET(DataPipes_ROOT_DIR "${LIBRARY_PATH}/DataPipes/${BUILD_OUTPUT}")
SET(StringVariable_ROOT_DIR "${LIBRARY_PATH}/StringVariable/${BUILD_OUTPUT}")
SET(ThreadPool_ROOT_DIR "${LIBRARY_PATH}/Thread-Pool/${BUILD_OUTPUT}")
SET(ed25519_ROOT_DIR "${LIBRARY_PATH}/ed25519/${BUILD_OUTPUT}")
if(BUILD_OS_TYPE STREQUAL "win32")
	SET(Libevent_DIR "${LIBRARY_PATH}/libevent/${BUILD_OUTPUT}/cmake")
else()
	SET(Libevent_DIR "${LIBRARY_PATH}/libevent/${BUILD_OUTPUT}/lib/cmake/libevent/")
endif()
SET(soxr_ROOT_DIR "${LIBRARY_PATH}/soxr/${BUILD_OUTPUT}")
SET(PortAudio_ROOT_DIR "${LIBRARY_PATH}/portaudio/${BUILD_OUTPUT}")
SET(fvad_ROOT_DIR "${LIBRARY_PATH}/libfvad/${BUILD_OUTPUT}")
SET(opus_ROOT_DIR "${LIBRARY_PATH}/opus/${BUILD_OUTPUT}")
SET(breakpad_ROOT_DIR "${LIBRARY_PATH}/breakpad/${BUILD_OUTPUT}")
SET(unbound_ROOT_DIR "${LIBRARY_PATH}/unbound/${BUILD_OUTPUT}")
SET(TeaSpeak_SharedLib_ROOT_DIR "${LIBRARY_PATH}/../shared/")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${LIBRARY_PATH}/spdlog/${BUILD_OUTPUT}")