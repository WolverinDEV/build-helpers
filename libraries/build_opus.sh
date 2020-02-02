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

function fix_avx() {
    echo "Fixing AVX parameters"
    # Windows
    sed -i 's/AdvancedVectorExtensions/NoExtensions/g' *.vcxproj

    # Linux
    sed -i "s/-mavx //g" CMakeFiles/opus.dir/flags.make
#    sed -i "s/-msse4.1 //g" CMakeFiles/opus.dir/flags.make
    return 0
}
_run_before_build="fix_avx"

_fpic=""
[[ ${build_os_type} == "linux" ]] && _fpic="-fPIC"
_cflags=""
[[ ${build_os_type} == "win32" ]] && _cflags="/arch:SSE"

# TODO: Patch the CMake file so that only the AVX & SEE4.1 files get -mavx. Else the optimizer will mess stuff up because it thinks its better to use "avx" instructions
cmake_build ${library_path} -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_C_FLAGS="${_fpic} ${_cflags}" -DOPUS_X86_PRESUME_AVX=OFF -DOPUS_X86_PRESUME_SSE4_1=OFF -DOPUS_X86_MAY_HAVE_SSE4_1=OFF -DOPUS_X86_MAY_HAVE_AVX=OFF
check_err_exit ${library_path} "Failed to build opus!"
set_build_successful ${library_path}
#
