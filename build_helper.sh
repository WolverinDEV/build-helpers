#!/usr/bin/env bash
# Basic functions required for library building
# Enforce library building with force_rebuild="library-a;library-b;..."
# Use force_rebuild="*" to rebuild everything

color_green='\e[92m'
color_normal='\e[39m'

build_helpers_defined=1

build_directory="_build"
install_directory="out"

#FIXME: Use real build path here, but for legacy reasons re're using the install path
function generate_build_path() {
    base_path=$(realpath $1)
    build_path="$base_path/${install_directory}/${build_os_type}_${build_os_arch}/"
    return 0
}

function requires_rebuild() {
    IFS=

    if [[ -z "${build_os_type}" ]]; then
        echo "Missing build os type! Rebuilding!"
        return 1
    fi
    if [[ -z "${build_os_arch}" ]]; then
        echo "Missing build os architecture! Rebuilding!"
        return 1
    fi

    base_path=$(realpath $1)
    build_name=$(basename $1)
    echo "Testing library build status at $build_name ($base_path)"

    if [[ "$force_rebuild" == "*" ]]; then
        echo "Force rebuild for everything. Rebuilding!"
        return 1
    fi

    if echo "$force_rebuild" | grep -q -E "(^|;)$build_name(;|$)"; then
        echo "Force rebuild for $build_name is set. Rebuilding!"
        return 1
    fi

    chk_file=".build_${build_os_type}_${build_os_arch}.txt"
    if [[ ! -e "$base_path/$chk_file" ]]; then
        echo "Build check file is missing. Rebuilding!"
        return 1
    fi

    echo "Reading data from $base_path/$chk_file"
    IFS=$'\n'
    data=($(cat "$base_path/$chk_file"))
    IFS=
    #echo "RData: ${data[@]}"

    if [[ "${data[0]}" -ne 1 ]]; then
        echo "Build data contains invalid version (${data[0]})! Rebuilding!"
        return 1
    fi

    if [[ "${data[1]}" != "success" ]]; then
        echo "Last build wasn't successful (${data[1]})! Rebuilding!"
        return 1
    fi

    git_rev=$(git -C ${base_path} rev-parse HEAD)
    if [[ $? -ne 0 ]]; then
        echo "Could not gather current git rev tag! Rebuilding!"
        return 1
    fi

    if [[ "${git_rev}" != "${data[2]}" ]]; then
        echo "Git rev tags not match (Current: ${git_rev}; Builded: ${data[2]}). Rebuilding!"
        return 1
    fi

    echo -en "$color_green"
    echo -e "Last build at ${data[3]} was successful!$color_normal Git rev: ${data[2]}. No need to rebuild."
    return 0
}

function set_build_successful() {
    IFS=

    if [[ -z "${build_os_type}" ]]; then
        echo "Failed to set flag successful because build os is undefined"
        return 1
    fi
    if [[ -z "${build_os_arch}" ]]; then
        echo "Failed to set flag successful because build arch is undefined"
        return 1
    fi

    base_path=$(realpath $1)
    build_name=$(basename $1)
    chk_file=".build_${build_os_type}_${build_os_arch}.txt"
    git_rev=$(git -C ${base_path} rev-parse HEAD)
    if [[ $? -ne 0 ]]; then
        echo "Failed to gather git rev tag! Failed to set successful flag!"
        return 1
    fi
    echo -en "$color_green"
    echo -e "Setting build @$build_name ($base_path) as successful for commit $git_rev$color_normal"

    data=()
    data+=("1") #Version
    data+=("success")
    data+=("${git_rev}")
    data+=("$(date)")

    IFS=$'\n'
    echo "${data[*]}" > "$base_path/$chk_file"
    IFS=
}

contains_element () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

#Set env variable 'make_targets' as array to specify specific targets
#Possible actions:
# - _run_before_build="command"
# - _run_before_install="command"
function cmake_build() {
    if [[ -z "${build_os_type}" ]]; then
        echo "Could not build cmake file because build os type has not been specified!"
        return 1
    fi
    if [[ -z "${build_os_arch}" ]]; then
        echo "Could not build cmake file because build arch type has not been specified!"
        return 1
    fi

    local base_path=$(realpath $1)
    local build_path="$base_path/${build_directory}/${build_os_type}_${build_os_arch}/"
    local install_path="$base_path/${install_directory}/${build_os_type}_${build_os_arch}/"
    if [[ ! -d ${base_path} ]]; then
        echo "Missing target directory. CMake build failed"
        return 1
    fi


    if [[ -d ${build_path} ]]; then
        echo "Deleting old build directory"
        rm -r ${build_path}
        [[ $? -ne 0 ]] && {
            echo "Failed to delete old build directory!"
            return 1
        }
    fi

    echo "Creating build directory ${build_path}"
    mkdir -p ${build_path}
    [[ $? -ne 0 ]] && {
        echo "Failed to create build directory!"
        return 1
    }

    local parameters=(${@:2})
    local final_parms=()
    declare -A final_definitions

    #Merge env variables with definitions
    IFS=" "
    for i in $(seq -s' ' 2 ${#@}); do
        parameter="$(eval echo \${$i})"
        if [[ "${parameter}" != -D* ]]; then
            final_parms+=("\"${parameter}\"")
            continue
        fi

        def_key=$(echo "$parameter" | sed -n -E 's:^-D([A-Za-z_0-9]*)=(.*):\1:p')
        def_value="$(echo "$parameter" | sed -n -E 's:^-D([A-Za-z_0-9]*)=(.*):\2:p')"

        [[ -z ${final_definitions[$def_key]} ]] && {
            final_definitions[$def_key]="${def_value}"
        } || {
            final_definitions[$def_key]="${final_definitions[$def_key]} ${def_value}"
        }
    done

    #TODO: May add a warning?
    #If given override the install prefix!
    final_definitions["CMAKE_INSTALL_PREFIX"]="$install_path"

    #Apply general env values
    #C_FLAGS; CXX_FLAGS
    [[ ! -z "${C_FLAGS}" ]] && final_definitions["CMAKE_C_FLAGS"]="${final_definitions['CMAKE_C_FLAGS']} ${C_FLAGS}"
    [[ ! -z "${CXX_FLAGS}" ]] && final_definitions["CMAKE_CXX_FLAGS"]="${final_definitions['CMAKE_CXX_FLAGS']} ${CXX_FLAGS}"

    local definition_string=""
    for i in "${!final_definitions[@]}"
    do
        definition_string="${definition_string} -D$i=\"${final_definitions[$i]}\""
    done
    #Cut of the start space
    [[ ! -z ${definition_string} ]] && definition_string=${definition_string:1}

    local _cmake_generator=""
    [[ -n "${build_cmake_generator}" ]] && _cmake_generator="${build_cmake_generator}"
    [[ -z "${_cmake_generator}" && "${build_os_type}" == "win32" ]] && _cmake_generator=" -G\"Visual Studio 15 2017 Win64\""
    local cmake_command="cmake $base_path$base_path_suffix ${_cmake_generator} ${final_parms[*]} ${definition_string} ${CMAKE_OPTIONS}"

    local origin_directory=$(pwd)
    cd ${build_path}
    [[ $? -ne 0 ]] && {
        echo "Failed to enter build directory!"
        return 1
    }

    #echo "Basic parameters: ${final_parms[*]}"
    #echo "Final definitions: ${definition_string}"

    echo "Executing cmake command:"
    echo "> $cmake_command"
    eval ${cmake_command}
    if [[ $? -ne 0 ]]; then
        echo "Failed to generate build file with cmake! Status code: $?"
        return 1
    fi

    local make_command=""
    local make_command_target=""
    local make_install_command=""
    if [[ "${build_os_type}" == "linux" ]]; then
        make_command="make ${CMAKE_MAKE_OPTIONS}"
        make_command_target="make ${CMAKE_MAKE_OPTIONS} %target%"
        make_install_command="make install"
    elif [[ "${build_os_type}" == "win32" ]]; then
        _config=""
        [[ ! -z "${final_definitions["CMAKE_BUILD_TYPE"]}" ]] && _config="--config ${final_definitions["CMAKE_BUILD_TYPE"]}"

        make_command="cmake --build . -j32 ${_config}"
        make_command_target="cmake --build . --target %target% -j32 ${_config}"
        make_install_command="cmake --build . ${_config} --target install"
    else
        echo "OS type unknown"
        return 1
    fi

    [[ ! -z "${_run_before_build}" ]] && {
        eval "${_run_before_build}"
        check_err_exit $1 "Failed to execute prebuild command"
    }

    if [[ ! -z "${make_targets}" ]]; then
        for target in ${make_targets[@]}; do
            make_command=$(echo "${make_command_target}" | sed "s:%target%:$target:g")
            echo "Executing build command for target ${target}:"
            echo "> $make_command"
            eval "${make_command}"
            if [[ $? -ne 0 && "$?" != "0" ]]; then
                echo "Failed to build project! Status code: $?"
                return 1
            fi
        done
    else
        echo "Executing build command:"
        echo "> $make_command"
        eval "${make_command}"
        if [[ $? -ne 0 && "$?" != "0" ]]; then
            echo "Failed to build project! Status code: $?"
            return 1
        fi
    fi
    if [[ -d "${install_path}" ]]; then
        echo "Deleting old install dir"
        rm -r "${install_path}"
        [[ $? -ne 0 ]] && { echo "Failed to remove old install dir"; exit 1; }
    fi

    [[ ! -z "${_run_before_install}" ]] && {
        eval "${_run_before_install}"
        check_err_exit $1 "Failed to execute preinstall command"
    }

    echo "Executing install command:"
    echo "> $make_install_command"
    eval "${make_install_command}"
    if [[ $? -ne 0 ]]; then
        echo "Failed to install project! Status code: $?"
        return 1
    fi

    cd ${origin_directory}
    return 0
}

function err_exit() {
    if [[ ${1} =~ __* ]]; then
        echo -e "\e[1;31mFailed to build project ${1:2}. Status code: ${error_code}"
    else
        echo -e "\e[1;31mFailed to build project $(basename $1) at $(realpath $1). Status code: ${error_code}"
    fi
    [[ ${#@} -gt 1 ]] && echo "${@:2}"
    echo -e "Aborting build\e[0;39m"
    exit 1
}

function check_err_exit() {
    error_code=$?
    [[ ${error_code} -eq 0 || "${error_code}" == "0" ]] && return 0
    err_exit $@
}

function pline() {
    local width="150"
    local padding="$(printf '%0.1s' ={1..120})"
    printf "%*.*s $color_green%s$color_normal %*.*s\n" 0 "$(( ($width - 2 - ${#1}) / 2))" "$padding" "$1" 0 "$(( ($width - 1 - ${#1}) / 2 ))" "$padding"
}

function format_time() {
    local time_needed_s=$(($1/1000000000))
    local time_needed_m=$(($time_needed_s/60))
    local time_needed_s=$(($time_needed_s - $time_needed_m * 60))

    time=""
    if [[ ${time_needed_m} != "0" ]]; then
        [[ -z ${time} ]] && time="$time_needed_m min" || time="${time} $time_needed_m min"
    fi
    if [[ ${time_needed_s} != "0" ]]; then
        [[ -z ${time} ]] && time="$time_needed_s sec" || time="${time} $time_needed_s sec"
    fi

    [[ -z ${time} ]] && time="0 sec"
}

declare -A task_timings
function begin_task() {
    local name="$1"
    local display_name="$2"

    task_timings[$name]="$(date +%s%N)"
    pline "$display_name"
}

function end_task() {
    local name="$1"
    local display_name="$2"

    time_end=$(date +%s%N)
    time_start=${task_timings[$name]}
    format_time $(($time_end-$time_start))
    pline "$display_name ($time)"
}
