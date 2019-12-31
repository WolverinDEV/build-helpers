#!/usr/bin/env bash

[[ -z "${build_helper_file}" ]] && {
	echo "Missing build helper file. Please define \"build_helper_file\""
	exit 1
}
source ${build_helper_file}
[[ $build_helpers_defined -ne 1 ]] && {
    echo "Failed to include build helpers from (${build_helper_file})."
    exit 1
}

requires_rebuild ${library_path}
[[ $? -eq 0 ]] && exit 0

if [[ ${build_os_type} == "linux" ]]; then
    if ! dpkg-query -l golang-go &>/dev/null; then
        echo "Install golang-go"
        sudo apt-get install golang-go
    fi
    check_err_exit ${library_path} "Failed to install libraries!"

    cd ${library_path}
    [[ $? -ne 0 ]] && exit 1
    [[ -d lib ]] && rm -r lib
    [[ $? -ne 0 ]] && exit 2

    mkdir lib && cd lib || exit 2
    ln -s ../build/ssl/libssl.so .
    ln -s ../build/crypto/libcrypto.so .
    ln -s ../include/ .
    cd ..

    cat include/openssl/opensslv.h | grep "OPENSSL_VERSION_NUMBER" &> /dev/null
    if [[ $? -ne 0 ]]; then
        echo "#if false
    # define OPENSSL_VERSION_NUMBER  0x1010008fL
    #endif" > include/openssl/opensslv.h
    fi
    cd ..
fi

generate_build_path "${library_path}"
if [[ -d ${build_path} ]]; then
    echo "Removing old build directory"
    rm -r ${build_path}
fi
mkdir -p ${build_path}
check_err_exit ${library_path} "Failed to create build directory"
cd ${build_path}
check_err_exit ${library_path} "Failed to enter build directory"

if [[ ${build_os_type} == "linux" ]]; then
    if [[ "x86" == "${build_os_arch}" ]]; then
        echo "Build boring SSL in 32 bit mode!"
        T32="-DCMAKE_TOOLCHAIN_FILE=../util/32-bit-toolchain.cmake"
    fi

    cmake ../../ -DOPENSSL_NO_ASM=ON -DCMAKE_CXX_FLAGS="-fPIC -Wno-error=format= -Wno-error=format-extra-args -Wno-error=misleading-indentation -Wno-error=maybe-uninitialized ${CXX_FLAGS}" -DBUILD_SHARED_LIBS=ON -DCMAKE_C_FLAGS="${C_FLAGS} -fPIC -Wno-error=misleading-indentation -Wno-error=maybe-uninitialized" -DCMAKE_BUILD_TYPE=Release ${CMAKE_OPTIONS} -DCMAKE_VERBOSE_MAKEFILE=1 ${T32}
    check_err_exit ${library_path} "Failed to execute cmake!"
    make ${CMAKE_MAKE_OPTIONS}
    check_err_exit ${library_path} "Failed to build!"
    #make install
elif [[ ${build_os_type} == "win32" ]]; then
    cmake ../../ -G"Visual Studio 14 2015 Win64" -DOPENSSL_NO_ASM=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=. -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded"
    check_err_exit ${library_path} "Failed generate build files!"

    cmake --build .  --target crypto --config release -j 8
    #MSBuild.exe //p:Configuration=Release //p:Platform=x64 crypto/crypto.vcxproj
    check_err_exit ${library_path} "Failed to build crytp!"

    cmake --build .  --target ssl --config release -j 8
    #MSBuild.exe //p:Configuration=Release //p:Platform=x64 ssl/ssl.vcxproj
    check_err_exit ${library_path} "Failed to build ssl!"
else
    echo "Invalid OS!"
    exit 1
fi
cd ../../../

set_build_successful ${library_path}
