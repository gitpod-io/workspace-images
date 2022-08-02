#!/usr/bin/env bash
# export PYTHONPATH="${GP_PYENV_MIRROR}/site/${PYENV_VERSION}" # `pip install` will use this path.
# # Do not set PIP_TARGET when `--user` arg is passed to `pip install` to avoid
# ## ERROR: Can not combine '--user' and '--target'.
# if [[ ! "$*" =~ pip[0-9]?\ install.*--user ]]; then {
# 	export PIP_TARGET="$PYTHONPATH" PIP_UPGRADE=true
# }; fi

# Do not set PIP_USER when `--target` arg is passed to `pip install` to avoid
## ERROR: Can not combine '--user' and '--target'.
# source "$HOME/.gp_pyenv.d/userbase.bash"
export PYTHONUSERBASE="$GP_PYENV_MIRROR/user/${PYENV_VERSION%%:*}"
if [[ "$*" =~ ^pip ]] || [[ "$*" =~ ^python.*-m\ pip ]] && [[ ! "$*" =~ pip.*install.*--target ]]; then {
	export PIP_USER=true PIP_NO_WARN_SCRIPT_LOCATION=false
}; fi
