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
SET(Boringssl_ROOT_DIR "${LIBRARY_PATH}/boringssl/lib/")
SET(TomMath_ROOT_DIR "${LIBRARY_PATH}/tommath/${BUILD_OUTPUT}")
SET(TomCrypt_ROOT_DIR "${LIBRARY_PATH}/tomcrypt/${BUILD_OUTPUT}")
SET(CXXTerminal_ROOT_DIR "${LIBRARY_PATH}/CXXTerminal/${BUILD_OUTPUT}")
set(yaml-cpp_DIR "${LIBRARY_PATH}/yaml-cpp/${BUILD_OUTPUT}share/cmake/yaml-cpp/")
SET(DataPipes_ROOT_DIR "${LIBRARY_PATH}/DataPipes/${BUILD_OUTPUT}")
SET(StringVariable_ROOT_DIR "${LIBRARY_PATH}/StringVariable/${BUILD_OUTPUT}")
SET(ThreadPool_ROOT_DIR "${LIBRARY_PATH}/Thread-Pool/${BUILD_OUTPUT}")
SET(ed25519_ROOT_DIR "${LIBRARY_PATH}/ed25519/${BUILD_OUTPUT}")
SET(Jemalloc_ROOT_DIR "${LIBRARY_PATH}/jemalloc/${BUILD_OUTPUT}")
SET(jsoncpp_ROOT_DIR "${LIBRARY_PATH}/jsoncpp/${BUILD_OUTPUT}")
SET(yaml-cpp_ROOT_DIR "${LIBRARY_PATH}/yaml-cpp/${BUILD_OUTPUT}/share/cmake/yaml-cpp/")
list(APPEND CMAKE_MODULE_PATH "${LIBRARY_PATH}/protobuf/${BUILD_OUTPUT}/lib/cmake/")
if(BUILD_OS_TYPE STREQUAL "win32")
	SET(Libevent_DIR "${LIBRARY_PATH}/libevent/${BUILD_OUTPUT}/cmake")
else()
	SET(Libevent_DIR "${LIBRARY_PATH}/libevent/${BUILD_OUTPUT}/lib/cmake/libevent/")
endif()
SET(opus_ROOT_DIR "${LIBRARY_PATH}/opus/${BUILD_OUTPUT}")
SET(Breakpad_ROOT_DIR "${LIBRARY_PATH}/breakpad/${BUILD_OUTPUT}")

set(spdlog_DIR "${LIBRARY_PATH}/spdlog/${BUILD_OUTPUT}/lib/spdlog/cmake/")
set(Libevent_DIR "${LIBRARY_PATH}/event/${BUILD_OUTPUT}/lib/libevent/")
list(APPEND CMAKE_MODULE_PATH "${LIBRARY_PATH}/spdlog/${BUILD_OUTPUT}")