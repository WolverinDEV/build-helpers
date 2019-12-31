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


_fpic=""
[[ ${build_os_type} == "linux" ]] && _fpic="-fPIC"

_cmake_options=""
[[ ${build_os_type} == "win32" ]] && _cmake_options="-DMSVC_RUNTIME=static"

[[ -z "${tommath_path}" ]] && {
  echo "Please specify libtommath math"
  exit 1
}

requires_rebuild ${library_path}
[[ $? -ne 0 ]] && {
    [[ -z "${tommath_library}" ]] && tommath_library="${tommath_path}/libtommathStatic.a"
    [[ -z "${tommath_include}" ]] && tommath_include="${tommath_path}/include/"

    # Convert the path
    [[ ${build_os_type} == "win32" ]] && {
        tommath_library="$(cygpath -w ${tommath_library} | sed 's:\\:\\\\:g')"
        tommath_include="$(cygpath -w ${tommath_include} | sed 's:\\:\\\\:g')"
    }

    cmake_build ${library_path} -DCMAKE_C_FLAGS="${_fpic} -DUSE_LTM -DLTM_DESC -I$tommath_include " -DCMAKE_BUILD_TYPE=RelWithDebInfo ${_cmake_options}
    check_err_exit ${library_path} "Failed to build tomcrypt!"
    set_build_successful ${library_path}
}
exit 0
