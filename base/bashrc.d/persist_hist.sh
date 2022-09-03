#!/usr/bin/env bash
if test -e "$GITPOD_REPO_ROOT" && test ! -v HIST_PERIST_INIT && export HIST_PERIST_INIT=true; then {
	# Taken from https://github.com/axonasif/dotfiles/blob/34c8663cac2656cdfb0ade40bcf6317c97cc239d/src/config/shell.sh#L7
	function config::shell::persist_history() {
		local -r _shell_hist_files=(
			"${HISTFILE:-"$HOME/.bash_history"}"
			"${HISTFILE:-"$HOME/.zsh_history"}"
			"$HOME/.local/share/fish/fish_history"
		)

		# Use workspace persisted history
		local _workspace_persist_dir="/workspace/.persist"
		mkdir -p "$_workspace_persist_dir"
		local _hist
		for _hist in "${_shell_hist_files[@]}"; do {
			mkdir -p "${_hist%/*}"
			_hist_name="${_hist##*/}"
			if test ! -e "$_workspace_persist_dir/$_hist_name"; then {
				printf '' >"$_hist"
				mv "$_hist" "$_workspace_persist_dir/"
			}; fi
			ln -sf "$_workspace_persist_dir/${_hist_name}" "$_hist"
			unset _hist_name
		}; done
	}
	config::shell::persist_history || :
}; fi
