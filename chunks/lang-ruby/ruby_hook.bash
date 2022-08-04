#!/usr/bin/env bash
function gitpod_init() {
	if test -e "$GITPOD_REPO_ROOT"; then {
		local rvmrc_string="rvm_gems_path=/workspace/.rvm"
		local rvmrc_file="$HOME/.rvmrc"
		if ! grep -q "$rvmrc_string" "$rvmrc_file" 2>/dev/null; then {
			printf '%s\n' "$rvmrc_string" >>"$rvmrc_file"
		}; fi
		export GEM_HOME="/workspace/.rvm"
	}; fi

	local rvm_script="$HOME/.rvm/scripts/rvm"
	# shellcheck source=/dev/null
	[[ -s "$rvm_script" ]] && source "$rvm_script"
	export PATH="$GEM_HOME/bin:$PATH"
	export GEM_PATH="$GEM_HOME:$GEM_PATH"
}

gitpod_init
unset -f gitpod_init
