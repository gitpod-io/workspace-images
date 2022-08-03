#!/usr/bin/env bash
function pyenv_gitpod_init() {
	if test -e "$GITPOD_REPO_ROOT"; then {
		export PYENV_HOOK_PATH="$HOME/.gp_pyenv.d"
		export GP_PYENV_MIRROR="/workspace/.pyenv_mirror"
		export GP_PYENV_FAKEROOT="$GP_PYENV_MIRROR/fakeroot"
		export PYTHONUSERBASE="$GP_PYENV_MIRROR/user/current"

		if test ! -v GP_PYENV_INIT; then {
			# Restore installed python versions
			local target version_dir
			for version_dir in "$GP_PYENV_FAKEROOT/versions/"*; do {
				target="$PYENV_ROOT/versions/${version_dir##*/}"
				mkdir -p "$target" 2>/dev/null
				if ! mountpoint -q "$target" && ! sudo mount --bind "$version_dir" "$target" 2>/dev/null; then {
					rm -rf "$target"
					ln -s "$version_dir" "$target"
				}; fi
			}; done 2>/dev/null

			# Persistent `pyenv global` version
			local p_version_file="$GP_PYENV_FAKEROOT/version"
			local o_version_file="$PYENV_ROOT/version"
			if test ! -e "$p_version_file"; then {
				mkdir -p "${p_version_file%/*}"
				mv "$o_version_file" "$p_version_file"
			}; fi
			ln -sf "$p_version_file" "$o_version_file"

			# Init userbase hook
			# shellcheck source=$HOME
			(PYENV_VERSION="$(pyenv version-name)" && export PYENV_VERSION && source "$HOME/.gp_pyenv.d/userbase.bash")
		}; fi && export GP_PYENV_INIT=true

		# Set $HOME/.pyenv/shims/python as the default Interpreter for ms-python.python VSCode extension
		local settings_name="python.defaultInterpreterPath"
		local settings_value="$HOME/.pyenv/shims/python"
		local machine_settings_file="/workspace/.vscode-remote/data/Machine/settings.json"
		if ! grep -q "$settings_name" "$machine_settings_file" 2>/dev/null; then {
			if test ! -e "$machine_settings_file"; then {
				mkdir -p "${machine_settings_file%/*}"
				printf '{\n\t"%s": "%s"\n}\n' "$settings_name" "$settings_value" >"$machine_settings_file"
			}; else {
				sed -i "1s|^{|{ \"$settings_name\": \"$settings_value\"\n|" "$machine_settings_file"
			}; fi
		}; fi

		# Poetry customizations
		export POETRY_CACHE_DIR="$GP_PYENV_MIRROR/poetry"
	}; fi
}

pyenv_gitpod_init
unset -f pyenv_gitpod_init

# Do not init when sourced internally from `pyenv`
if test ! -v PYENV_DIR; then {
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
}; fi
