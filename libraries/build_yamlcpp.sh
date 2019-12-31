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

_cxx_flags=""
[[ ${build_os_type} == "linux" ]] && _cxx_flags="-D_GLIBCXX_USE_CXX11_ABI=1 -std=c++11 -fPIC"
cmake_build ${library_path} -DYAML_CPP_BUILD_TESTS=OFF -DYAML_CPP_BUILD_TOOLS=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="${_cxx_flags}"
check_err_exit ${library_path} "Failed to build yaml-cpp!"
set_build_successful ${library_path}
