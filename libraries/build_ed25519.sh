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

_fpic=""
[[ ${build_os_type} == "linux" ]] && _fpic="-fPIC"


crypto_include="`pwd`/boringssl/include/"
# Convert the path
[[ ${build_os_type} == "win32" ]] && {
    crypto_include="$(cygpath -w ${crypto_include} | sed 's:\\:\\\\:g')"
}

#-L`pwd`/boringssl/build/ssl/ -L`pwd`/boringssl/build/crypto/
cmake_build ${library_path} -DCMAKE_C_FLAGS="${_fpic} -I$crypto_include" -DUSE_OPENSSL=OFF -DBUILD_TESTS=OFF -DCMAKE_CXX_FLAGS="${_fpic}" -DCMAKE_BUILD_TYPE=RelWithDebInfo
check_err_exit ${library_path} "Failed to build ed25519!"
set_build_successful ${library_path}
