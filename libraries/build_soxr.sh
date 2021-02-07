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


library_path="soxr"
requires_rebuild ${library_path}
[[ $? -eq 0 ]] && exit 0

_fpic=""
[[ ${build_os_type} == "linux" ]] && _fpic="-fPIC"
cmake_build ${library_path} -DCMAKE_C_FLAGS="${_fpic}" -DBUILD_SHARED_RUNTIME=OFF -DWITH_OPENMP=OFF -DBUILD_TESTS=OFF -DBUILD_SHARED_LIBS=OFF -DBUILD_EXAMPLES=OFF
check_err_exit ${library_path} "Failed to build soxr!"
set_build_successful ${library_path}
