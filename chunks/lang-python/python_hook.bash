#!/usr/bin/env bash

# shellcheck disable=SC2120

function pyenv_gitpod_init() {
	if test -e "$GITPOD_REPO_ROOT"; then {
		export PYENV_HOOK_PATH="$HOME/.gp_pyenv.d"
		export GP_PYENV_MIRROR="/workspace/.pyenv_mirror"
		export GP_PYENV_FAKEROOT="$GP_PYENV_MIRROR/fakeroot"
		export PYTHONUSERBASE="$GP_PYENV_MIRROR/user/current"
		export PYTHONUSERBASE_VERSION_FILE="${PYTHONUSERBASE%/*}/.mounted_version"
		export PIP_CACHE_DIR="$GP_PYENV_MIRROR/pip_cache"

		if test ! -v GP_PYENV_INIT; then {

			function vscode::add_settings() {
				# From https://github.com/axonasif/dotfiles/blob/main/src/utils/common.sh
				local lockfile="/tmp/.vscs_add.lock"
				local vscode_machine_settings_file="/workspace/.vscode-remote/data/Machine/settings.json"
				local vscode_machine_settings_file="${SETTINGS_TARGET:-$vscode_machine_settings_file}"
				trap 'rm -f $lockfile' ERR SIGINT RETURN
				while test -e "$lockfile" && sleep 0.2; do {
					continue
				}; done
				touch "$lockfile"

				local input="${1:-}"

				if test ! -n "$input"; then {
					# Read from standard input
					read -t0.5 -u0 -r -d '' input || :
				}; elif test -e "$input"; then {
					# Read the input file into a variable
					input="$(<"$input")"
				}; else {
					printf 'error: %s\n' "${FUNCNAME[0]}: $input does not exist"
					exit 1
				}; fi

				if test -n "${input:-}"; then {
					# Create the vscode machine settings file if it doesnt exist
					if test ! -e "$vscode_machine_settings_file"; then {
						mkdir -p "${vscode_machine_settings_file%/*}"
					}; fi

					# Check json syntax
					if test ! -s "$vscode_machine_settings_file" || ! jq -reM '""' "$vscode_machine_settings_file" 1>/dev/null; then {
						printf '{}\n' >"$vscode_machine_settings_file"
					}; fi

					# Remove any trailing commas
					sed -i -e 's|,}|\n}|g' -e 's|, }|\n}|g' -e ':begin;$!N;s/,\n}/\n}/g;tbegin;P;D' "$vscode_machine_settings_file"

					# Merge the input settings with machine settings.json
					local tmp_file="${vscode_machine_settings_file%/*}/.tmp"
					cp -a "$vscode_machine_settings_file" "$tmp_file"
					jq -s '.[0] * .[1]' - "$tmp_file" <<<"$input" >"$vscode_machine_settings_file"
					rm "$tmp_file"
				}; fi
			}

			# Restore installed python versions
			local target version_dir
			(
				shopt -s nullglob
				for version_dir in "$GP_PYENV_FAKEROOT/versions/"*; do {
					target="$PYENV_ROOT/versions/${version_dir##*/}"
					mkdir -p "$target" 2>/dev/null
					if ! mountpoint -q "$target" && ! sudo mount --bind "$version_dir" "$target" 2>/dev/null; then {
						rm -rf "$target"
						ln -s "$version_dir" "$target"
					}; fi
				}; done
			)

			# Persistent `pyenv global` version
			local p_version_file="$GP_PYENV_FAKEROOT/version"
			local o_version_file="$PYENV_ROOT/version"
			if test ! -e "$p_version_file"; then {
				mkdir -p "${p_version_file%/*}"
				if test -e "$o_version_file"; then {
					printf '%s\n' "$(<"$o_version_file")" >"$p_version_file" || :
				}; fi
			}; fi
			touch "$p_version_file"
			rm -f "$o_version_file"
			ln -sf "$p_version_file" "$o_version_file"

			# Init userbase hook
			pyenv global 1>/dev/null

			# Set $HOME/.pyenv/shims/python as the default Interpreter for ms-python.python VSCode extension
			vscode::add_settings <<-JSON
				{
					"python.defaultInterpreterPath": "$HOME/.pyenv/shims/python",
					"python.terminal.activateEnvironment": false
				}
			JSON
		}; fi && export GP_PYENV_INIT=true

		# Poetry customizations
		export POETRY_CACHE_DIR="$GP_PYENV_MIRROR/poetry"
	}; fi
}

pyenv_gitpod_init
unset -f pyenv_gitpod_init vscode::add_settings

# Do not init when sourced internally from `pyenv`
if test ! -v PYENV_DIR; then {
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
}; fi
