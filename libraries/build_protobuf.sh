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

#./${library_path}/libraries/build_event.sh
#check_err_exit ${library_path} "Failed to build library libevent"

_cxx_options=""
[[ ${build_os_type} == "linux" ]] && _cxx_options="-fPIC -std=c++11"
base_path_suffix="/cmake/"
cmake_build ${library_path} -Dprotobuf_BUILD_TESTS=OFF -DCMAKE_CXX_FLAGS="${_cxx_options}" -DCMAKE_BUILD_TYPE=RelWithDebInfo
check_err_exit ${library_path} "Failed to build protobuf!"
set_build_successful ${library_path}