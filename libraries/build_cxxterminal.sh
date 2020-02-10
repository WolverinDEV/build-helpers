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

[[ ! -z "${libevent_path}" ]] || {
  echo "Please specify the libevent path!"
  exit 1
}

_fpic=""
[[ ${build_os_type} == "linux" ]] && _fpic="-fPIC"
cmake_build ${library_path} -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_CXX_FLAGS="${_fpic}" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DENABLE_LIBEVENT=ON -DNO_EMBETTED_LIBEVENT=ON -DLibevent_DIR="`pwd`/${libevent_path}/out/${build_os_type}_${build_os_arch}/lib/cmake/libevent/" -DLIBEVENT_STATIC_LINK=ON
check_err_exit ${library_path} "Failed to build CXXTerminal!"
set_build_successful ${library_path}
