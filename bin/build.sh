#!/bin/bash

build_script_dir=$(dirname "${BASH_SOURCE[0]}")
build_project_dir=$(cd -P -- "$build_script_dir/.." && pwd -P)
source "$build_project_dir/lib/utils"

detect_platform

exec ${build_project_dir}/build/${BUILD_PLATFORM}/build.sh "$@"

