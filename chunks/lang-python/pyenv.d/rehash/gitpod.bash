#!/usr/bin/env bash
gitpod_shims=()
for file in "$GP_PYENV_MIRROR"/site/*/bin/*; do {
	gitpod_shims+=("${file##*/}")
}; done
make_shims "${gitpod_shims[@]}"
