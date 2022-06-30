#!/usr/bin/env bash
export PYTHONPATH="${GP_PYENV_MIRROR}/site/${PYENV_VERSION}" # `pip install` will use this path.
# Do not set PIP_TARGET when `--user` arg is passed to `pip install` to avoid
# ERROR: Can not combine '--user' and '--target'.
if [[ ! "$*" =~ pip[0-9]?\ install.*--user ]]; then {
	export PIP_TARGET="$PYTHONPATH" PIP_UPGRADE=true
}; fi
