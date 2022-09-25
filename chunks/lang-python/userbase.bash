#!/usr/bin/env bash
set -eu
if test -e "${GITPOD_REPO_ROOT:-}" && test "${BASH_SOURCE[1]}" == "$PYENV_ROOT/libexec/pyenv-global"; then {
	# # For pyenv-global hook
	# if test ! -v PYENV_VERSION && ; then {
	# shellcheck disable=SC2154
	PYENV_VERSION="${versions[0]}"
	if [[ ! "$PYENV_VERSION" =~ \.|system ]]; then {
		exit
	}; fi

	# }; fi
	pyenv_version="${PYENV_VERSION%%:*}"
	system_python_userbase="$PYTHONUSERBASE"
	userbase_dir="$GP_PYENV_MIRROR/user"
	versioned_python_userbase_dir="$userbase_dir/$pyenv_version"
	mounted_version_file="$PYTHONUSERBASE_VERSION_FILE"

	if test ! -s "$mounted_version_file"; then {
		mkdir -p "${mounted_version_file%/*}"
		printf '%s\n' "$pyenv_version" >"$mounted_version_file"
	}; fi

	mounted_version="$(<"$mounted_version_file")"

	# shellcheck disable=SC2034
	if ! mountpoint -q "$system_python_userbase" && not_mounted=true || test "$mounted_version" != "$pyenv_version"; then {
		mkdir -p "$system_python_userbase" "$versioned_python_userbase_dir" 2>/dev/null
		if test ! -v not_mounted; then {
			while mountpoint -q "$system_python_userbase"; do {
				sudo umount "$system_python_userbase" || sudo umount -l "$system_python_userbase"
			}; done
		}; fi
		if ! sudo mount --bind "$versioned_python_userbase_dir" "$system_python_userbase" 2>/dev/null; then {
			rm -rf "$system_python_userbase"
			ln -s "$versioned_python_userbase_dir" "$system_python_userbase"
		}; fi
		printf '%s\n' "$pyenv_version" >"$mounted_version_file"
	}; fi
}; fi
