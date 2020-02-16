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

    cat include/openssl/opensslv.h | grep "OPENSSL_VERSION_NUMBER" &> /dev/null
    if [[ $? -ne 0 ]]; then
        echo "#if false
    # define OPENSSL_VERSION_NUMBER  0x1010008fL
    #endif" > include/openssl/opensslv.h
    fi

    cat ssl/test/bssl_shim.cc | grep "__STDC_FORMAT_MACROS" &> /dev/null
    if [[ $? -ne 0 ]]; then
        echo "`echo -e "#define __STDC_FORMAT_MACROS\n\n"``cat ssl/test/bssl_shim.cc`" > ssl/test/bssl_shim.cc
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
        T32="-DCMAKE_TOOLCHAIN_FILE=../../util/32-bit-toolchain.cmake"
    fi

    cmake ../../ -DOPENSSL_NO_ASM=ON -DCMAKE_CXX_FLAGS="-fPIC -Wno-error=format= -Wno-error=attributes -Wno-error=format-extra-args -Wno-error=misleading-indentation -Wno-error=maybe-uninitialized ${CXX_FLAGS}" -DBUILD_SHARED_LIBS=ON -DCMAKE_C_FLAGS="${C_FLAGS} -fPIC -Wno-error=misleading-indentation -Wno-error=maybe-uninitialized" -DCMAKE_BUILD_TYPE=Release ${CMAKE_OPTIONS} -DCMAKE_VERBOSE_MAKEFILE=1 ${T32}
    check_err_exit ${library_path} "Failed to execute cmake!"
    make ${CMAKE_MAKE_OPTIONS}
    check_err_exit ${library_path} "Failed to build!"

    # Generate lib folder
    cd ../../
    if [[ ! -d lib ]]; then
        echo "Generating lib folder"
        mkdir "lib"
        check_err_exit ${library_path} "Failed to generate lib folder."
    fi
    cd lib; check_err_exit ${library_path} "Failed to enter lib dir"
    [[ -L libcrypto.so ]] && { echo "Removing old crypto link"; rm libcrypto.so; check_err_exit ${library_path} "Failed to remove old crypt link"; }
    [[ -L libssl.so ]] && { echo "Removing old ssl link"; rm libssl.so; check_err_exit ${library_path} "Failed to remove old ssl link"; }
    [[ -L include ]] && { echo "Removing old include link"; rm include; check_err_exit ${library_path} "Failed to remove old include link"; }

    ln -s ${build_path}/ssl/libssl.so .
    check_err_exit ${library_path} "Failed to create ssl link";

    ln -s ${build_path}/crypto/libcrypto.so .
    check_err_exit ${library_path} "Failed to create crypto link";

    ln -s ../include/ .
    check_err_exit ${library_path} "Failed to link include dir";

    cd ../../
elif [[ ${build_os_type} == "win32" ]]; then
    cmake ../../ -G"Visual Studio 14 2015 Win64" -DOPENSSL_NO_ASM=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=. -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded"
    check_err_exit ${library_path} "Failed generate build files!"

    cmake --build .  --target crypto --config release -j 8
    #MSBuild.exe //p:Configuration=Release //p:Platform=x64 crypto/crypto.vcxproj
    check_err_exit ${library_path} "Failed to build crytp!"

    cmake --build .  --target ssl --config release -j 8
    #MSBuild.exe //p:Configuration=Release //p:Platform=x64 ssl/ssl.vcxproj
    check_err_exit ${library_path} "Failed to build ssl!"
    cd ../../../
else
    echo "Invalid OS!"
    exit 1
fi

set_build_successful ${library_path}
