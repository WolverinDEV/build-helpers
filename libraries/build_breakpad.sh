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


if [[ ! ${build_os_type} == "linux" ]]; then
    echo "Linux support only!"
    exit 1
fi

requires_rebuild "${library_path}"
[[ $? -eq 0 ]] && exit 0

cd ${library_path} || { echo "failed to enter library path"; exit 1; }
git clone https://chromium.googlesource.com/linux-syscall-support src/third_party/lss
cd .. || { echo "failed to exit library path"; exit 1; }

generate_build_path "${library_path}"
if [[ -d ${build_path} ]]; then
    echo "Removing old build directory"
    rm -r ${build_path}
fi
mkdir -p ${build_path}
check_err_exit ${library_path} "Failed to create build directory"
cd ${build_path}
check_err_exit ${library_path} "Failed to enter build directory"

../../configure --prefix=`pwd`
check_err_exit ${library_path} "Failed to configure"
make CXXFLAGS="-std=c++11 ${CXX_FLAGS} -static-libgcc -static-libstdc++" CFLAGS="${C_FLAGS}" ${MAKE_OPTIONS}
check_err_exit ${library_path} "Failed to build"
make install
check_err_exit ${library_path} "Failed to install"
cd ../../../

# cmake_build ${library_path} -DCMAKE_C_FLAGS="-fPIC -I../../boringssl/include/" -DEVENT__DISABLE_TESTS=ON -DEVENT__DISABLE_OPENSSL=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo
# check_err_exit ${library_path} "Failed to build libevent!"
set_build_successful "${library_path}"
