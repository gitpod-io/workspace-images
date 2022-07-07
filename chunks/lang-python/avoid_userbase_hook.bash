#!/usr/bin/env bash
# When someone tries to install to userbase from a custom dockerfile but `/workspace` doesn't exist there
if [[ "$*" =~ pip.*install.*--user ]] && test ! -e "$GITPOD_REPO_ROOT"; then {
	for ((i = $#; i != 0; i--)); do {
		if test "$(eval "echo \$$i")" == "--user"; then {
			set -- "${@:1:$i-1}" "${@:$i+1}" # Removes the `--user` argument
		}; fi
	}; done
}; fi
