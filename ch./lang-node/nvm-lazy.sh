#!/bin/bash

export NVM_DIR="$HOME/.nvm"

node_versions=("$NVM_DIR"/versions/node/*)

if (("${#node_versions[@]}" > 0)); then
	PATH="$PATH:${node_versions[$((${#node_versions[@]} - 1))]}/bin"
fi

if [ -s "$NVM_DIR/nvm.sh" ]; then
	# load the real nvm on first use
	nvm() {
		# shellcheck disable=SC1090,SC1091
		source "$NVM_DIR"/nvm.sh
		nvm "$@"
	}
fi

if [ -s "$NVM_DIR/bash_completion" ]; then
	# shellcheck disable=SC1090,SC1091
	source "$NVM_DIR"/bash_completion
fi
