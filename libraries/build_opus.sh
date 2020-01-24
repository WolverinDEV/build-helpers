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

function win_fix_avx() {
    echo "Fixing WIN32 AVX parameters"
    sed -i 's/AdvancedVectorExtensions/NoExtensions/g' *.vcxproj
    return 0
}
_run_before_build="win_fix_avx"

_fpic=""
[[ ${build_os_type} == "linux" ]] && _fpic="-fPIC"
_cflags=""
[[ ${build_os_type} == "win32" ]] && _cflags="/arch:SSE"

cmake_build ${library_path} -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_C_FLAGS="${_fpic} ${_cflags}" -DOPUS_X86_PRESUME_AVX=OFF -DOPUS_X86_PRESUME_SSE4_1=OFF
check_err_exit ${library_path} "Failed to build opus!"
set_build_successful ${library_path}
#