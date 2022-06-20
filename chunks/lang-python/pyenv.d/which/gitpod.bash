#!/usr/bin/env bash
if test ! -x "$PYENV_COMMAND_PATH"; then {
	for bin in "${GP_PYENV_MIRROR}/site/"*"/bin/$PYENV_COMMAND"; do {
		PYENV_COMMAND_PATH="$bin"
		if test -x "$PYENV_COMMAND_PATH"; then {
			break
		}; fi
	}; done
}; fi
