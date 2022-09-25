#!/usr/bin/env bash
# export PYTHONPATH="${GP_PYENV_MIRROR}/site/${PYENV_VERSION}" # `pip install` will use this path.
# # Do not set PIP_TARGET when `--user` arg is passed to `pip install` to avoid
# ## ERROR: Can not combine '--user' and '--target'.
# if [[ ! "$*" =~ pip[0-9]?\ install.*--user ]]; then {
# 	export PIP_TARGET="$PYTHONPATH" PIP_UPGRADE=true
# }; fi

# For pyenv-shell mode
# shellcheck disable=SC2153
pyenv_version="${PYENV_VERSION%%:*}"
if test ! -e "$PYTHONUSERBASE_VERSION_FILE"; then {
	pyenv global 1>/dev/null
}; fi
mounted_version="$(<"$PYTHONUSERBASE_VERSION_FILE")"
if test "$pyenv_version" != "$mounted_version"; then {
	export PYTHONUSERBASE="${PYTHONUSERBASE%/*}/$pyenv_version"
}; fi

# For pyenv-global multiple-version shims
if [[ "$PYENV_VERSION" =~ : ]] && [[ "$PYENV_COMMAND_PATH" =~ "$GP_PYENV_MIRROR"/user ]] && [[ "$(<"$PYENV_COMMAND_PATH")" =~ \#\!("${GP_PYENV_FAKEROOT}"|"$PYENV_ROOT")/versions/([0-9]+(\.[0-9]+)*)/bin ]]; then {
	multi_shim_version="${BASH_REMATCH[2]}"
	if test "$mounted_version" != "$multi_shim_version"; then {
		export PYTHONUSERBASE="${PYTHONUSERBASE%/*}/$multi_shim_version"
	}; fi
}; fi 2>/dev/null

# Do not set PIP_USER when `--target` arg is passed to `pip install` to avoid
## ERROR: Can not combine '--user' and '--target'.
# source "$HOME/.gp_pyenv.d/userbase.bash"
if [[ "$*" =~ ^pip ]] || [[ "$*" =~ ^python.*-m\ pip ]] && [[ ! "$*" =~ pip.*install.*--target ]]; then {
	export PIP_USER=true PIP_NO_WARN_SCRIPT_LOCATION=false
}; fi
