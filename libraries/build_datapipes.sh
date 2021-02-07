#!/usr/bin/env bash

[[ -z "${build_helper_file}" ]] && {
	echo "Missing build helper file. Please define \"build_helper_file\""
	exit 1
}
source ${build_helper_file}
[[ $build_helpers_defined -ne 1 ]] && {
    echo "Failed to include build helpers."
    exit 1
}


requires_rebuild ${library_path}
[[ $? -eq 0 ]] && exit 0

_cxx_options=""
[[ ${build_os_type} != "win32" ]] && _cxx_options="-fPIC -static-libgcc -static-libstdc++"
[[ ${build_os_type} == "win32" ]] && _cxx_options="-DWIN32"

_crypto_type="boringssl"
[[ ${build_os_type} == "win32" ]] && _crypto_type="none"

_build_type="Release"
[[ ${build_os_type} == "win32" ]] && _build_type="Debug"

cmake_build ${library_path} -DCMAKE_BUILD_TYPE="${_build_type}" -DBUILD_SHARED=ON -DCrypto_ROOT_DIR="`pwd`/boringssl/lib" -DCRYPTO_TYPE="${_crypto_type}" -DBUILD_TESTS=OFF -DBUILD_EXAMPLES=OFF -DMSVC_RUNTIME=static
check_err_exit ${library_path} "Failed to build DataPipes!"
set_build_successful ${library_path}
