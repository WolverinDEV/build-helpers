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

cmake_build ${library_path} -DSPDLOG_BUILD_EXAMPLE=OFF -DSPDLOG_BUILD_EXAMPLE_HO=OFF -DSPDLOG_BUILD_TESTS=OFF -DSPDLOG_BUILD_TESTS_HO=OFF -DCMAKE_BUILD_TYPE=RelWithDebInfo
check_err_exit ${library_path} "Failed to build spdlog!"
set_build_successful ${library_path}
