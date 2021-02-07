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


if [[ ${build_os_type} == "win32" ]]; then
    echo "Windows does not require libunbound"
    echo "Dont building library"
    exit 0
fi

library_path="unbound"
requires_rebuild ${library_path}
[[ $? -eq 0 ]] && exit 0

generate_build_path "${library_path}"
library_event=`pwd`/libevent/out/${build_os_type}_${build_os_arch}/
library_boringssl=`pwd`/boringssl/lib/


if [[ -d ${build_path} ]]; then
    echo "Removing old build directory"
    rm -r ${build_path}
fi

cd ${library_path}
if [[ ${build_os_type} == "linux" ]]; then
	#Failed to build with BoringSSL, so we using openssl. No ABI stuff should be changed!
	# --with-ssl=${library_boringssl}
        echo "Install build to ${build_path}"
	./configure --prefix="${build_path}" --with-libunbound-only --with-libevent=${library_event} --enable-event-api --enable-shared=yes --enable-static=yes --with-pthreads
	check_err_exit ${library_path} "Failed to configure build"
	make CXXFLAGS="${CXX_FLAGS}" CFLAGS="${C_FLAGS} -fPIC" ${MAKE_OPTIONS}
	check_err_exit ${library_path} "Failed to build"
	make install
	check_err_exit ${library_path} "Failed to install"
else
    echo "Invalid OS!"
    exit 1
fi
cd ../

set_build_successful ${library_path}

