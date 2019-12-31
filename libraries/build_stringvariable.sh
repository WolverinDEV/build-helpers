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
_cmake_options=""
[[ ${build_os_type} == "win32" ]] && _cmake_options="-DMSVC_RUNTIME=static"
cmake_build ${library_path} -DCMAKE_CXX_FLAGS="${_fpic}" -DCMAKE_BUILD_TYPE=RelWithDebInfo ${_cmake_options}
check_err_exit ${library_path} "Failed to build StringVariable!"
set_build_successful ${library_path}
