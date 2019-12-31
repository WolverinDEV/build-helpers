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

if [[ ${build_os_type} != "win32" ]]; then
    cd ${library_path}

    #echo "Testing for libnice"
    #dpkg-query -l libnice-dev2 &>/dev/null
    #if [[ $? -ne 0 ]]; then
    #    echo "Installing libnice"
    #    sudo apt-get update
    #    sudo apt-get install -yes --force-yes libnice-dev
    #else
    #    echo "libnice already installed"
    #fi

    echo "Building dependencies"
    ./build_usrsctp.sh
    check_err_exit ${library_path} "Failed to build usrsctp!"
    ./build_srtp.sh
    check_err_exit ${library_path} "Failed to build srtp!"
    ./build_sdptransform.sh
    check_err_exit ${library_path} "Failed to build sdptransform!"
    cd ..
fi

[[ -z "${datapipes_webrtc}" ]] && datapipes_webrtc=1
[[ "${datapipes_webrtc}" -eq 1 ]] && _datapipes_webrtc="ON" || datapipes_webrtc="OFF"

_cxx_options=""
[[ ${build_os_type} != "win32" ]] && _cxx_options="-fPIC -static-libgcc -static-libstdc++"
[[ ${build_os_type} == "win32" ]] && _cxx_options="-DWIN32"
cmake_build ${library_path} -DCMAKE_BUILD_TYPE=Debug -DBUILD_SHARED=ON -DCrypto_ROOT_DIR="`pwd`/boringssl/" -DCRYPTO_TYPE="boringssl" -DCMAKE_CXX_FLAGS="${_cxx_options}" -DBUILD_TESTS=OFF -DBUILD_WEBRTC=${_datapipes_webrtc} -DMSVC_RUNTIME=static
check_err_exit ${library_path} "Failed to build DataPipes!"
set_build_successful ${library_path}
