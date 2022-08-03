#!/usr/bin/env bash

# shellcheck source=/dev/null
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

function gitpod_init() {
	if test -e "$GITPOD_REPO_ROOT"; then {
		local rvmrc_string="rvm_gems_path=/workspace/.rvm"
		local rvmrc_file="$HOME/.rvmrc"
		if ! grep -q "$rvmrc_string" "$rvmrc_file" 2>/dev/null; then {
			printf '%s\n' "$rvmrc_string" >>"$rvmrc_file"
		}; fi
		export GEM_HOME="/workspace/.rvm"
	}; else {
		export GEM_HOME="$HOME/.rvm"
	}; fi

	export PATH="$GEM_HOME/bin:$PATH"
	export GEM_PATH="$GEM_HOME:$GEM_PATH"
}

gitpod_init
unset -f gitpod_init
