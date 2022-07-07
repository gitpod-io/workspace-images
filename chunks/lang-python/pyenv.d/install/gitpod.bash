#!/usr/bin/env bash
ver="${DEFINITION##*/}"
if test -e "$PYENV_ROOT/versions/$ver" && test ! -e "$GP_PYENV_FAKEROOT/versions/$ver" &&
	[ -z "$FORCE" ] && [ -z "$SKIP_EXISTING" ]; then {
		echo "pyenv: $ver already exists" >&2
		read -rp "continue with installation? (y/N) "

		if [[ ! "${REPLY,,}" =~ y ]]; then {
			exit 1
		}; fi
	}; fi

ORIG_PYENV_ROOT="$PYENV_ROOT"
PYENV_ROOT="$GP_PYENV_FAKEROOT" # Temporarily hijack PYENV_ROOT

function after_job() {
	PYENV_ROOT="$ORIG_PYENV_ROOT"
	unset GP_PYENV_INIT
	# shellcheck disable=SC1090
	source "$HOME/.bashrc.d/"*-python
	# pyenv-rehash && PYENV_VERSION="$ver" pip install --upgrade pip
}

after_install "after_job"
