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
generate_build_path ${library_path}

cd ${library_path}
if ! [[ -f configure ]]; then
	autoconf
	if [[ $? -ne 0 ]]; then
		echo "Failed to create configure file"
		exit 1
	fi
	if ! [[ -f configure  ]]; then
		echo "Failed to create configure file"
		exit 1
	fi
fi

if [[ -d ${build_path} ]]; then
    rm -r ${build_path}
    check_err_exit ${library_path} "Failed to remove build path!"
fi
mkdir -p ${build_path}
check_err_exit ${library_path} "Failed to create build path!"

cd ${build_path}
check_err_exit ${library_path} "Failed to enter build path!"

../../configure --enable-munmap --prefix=`pwd`
if [[ $? -ne 0 ]]; then
	echo "Failed to create makefile"
	exit 1
fi

(cat Makefile | sed 's/.*$(CC) $(DSO_LDFLAGS) $(call RPATH,$(RPATH_EXTRA)) $(LDTARGET) $+ $(LDFLAGS) $(LIBS) $(EXTRA_LDFLAGS).*/	$(CXX) $(DSO_LDFLAGS) $(call RPATH,$(RPATH_EXTRA)) $(LDTARGET) $+ $(LDFLAGS) $(LIBS) $(EXTRA_LDFLAGS)/') > tmp
rm Makefile
mv tmp Makefile
make -j 12 LIBS="-pthread -static-libgcc -static-libstdc++ -fPIC" CFLAGS="-static-libgcc -static-libstdc++ -fPIC" CXXFLAGS="-static-libgcc -static-libstdc++ -fPIC"
#make -j 12 LIBS="-pthread -static-libgcc -static-libstdc++" CFLAGS="-fPIC" CXXFLAGS="-fPIC"
#make -j 12 LIBS="-pthread -lm -l/usr/lib/gcc/x86_64-linux-gnu/5/libstdc++.a" ${MAKE_OPTIONS} CFLAGS="-shared -static-libstdc++ -static-libgcc -fPIC" CXXFLAGS="-static-libstdc++ -static-libgcc -shared -fPIC"
if [[ $? -ne 0 ]]; then
	echo "Failed to build jemalloc"
	exit 1
fi

make install &>/dev/null
if [[ $? -ne 0 ]]; then #Workaround because the install fails
	#exit 0
    echo "" &> /dev/null
fi

cd ../../../
set_build_successful ${library_path}
