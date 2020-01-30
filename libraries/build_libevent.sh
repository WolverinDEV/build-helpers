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

make_targets=("event_static")
[[ ${build_os_type} == "linux" ]] && make_targets+=("event_pthreads_static")
#cmake ../../ -G"Visual Studio 16 2019" -DEVENT_INSTALL_CMAKE_DIR=cmake -DCMAKE_INSTALL_PREFIX=. -DEVENT__DISABLE_BENCHMARK=ON -DEVENT__LIBRARY_TYPE=BOTH -DEVENT__MSVC_STATIC_RUNTIME=ON -DEVENT__DISABLE_TESTS=ON -DEVENT__DISABLE_SAMPLES=ON -DEVENT__DISABLE_OPENSSL=ON
cmake_build ${library_path} -DCMAKE_C_FLAGS="${_fpic} -I../../boringssl/include/" -DEVENT__DISABLE_BENCHMARK=ON -DEVENT__LIBRARY_TYPE=BOTH -DEVENT__MSVC_STATIC_RUNTIME=ON -DEVENT__DISABLE_TESTS=ON -DEVENT__DISABLE_SAMPLES=ON -DEVENT__DISABLE_OPENSSL=ON -DCMAKE_BUILD_TYPE="Release"
check_err_exit ${library_path} "Failed to build libevent!"
set_build_successful ${library_path}
