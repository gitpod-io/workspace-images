#!/usr/bin/env bash
shopt -s nullglob
gitpod_shims=()
for file in "$GP_PYENV_MIRROR"/user/*/bin/*; do {
	gitpod_shims+=("${file##*/}")
}; done 2>/dev/null
make_shims "${gitpod_shims[@]}"
