#!/usr/bin/env bash
function fake_cleanup() { # function read()
	# builtin read "$@";
	# if [[ "${REPLY,,}" =~ ^y ]]; then {
	MIRROR_VER_DIR="$GP_PYENV_FAKEROOT/versions/${VERSION_NAME}"
	# ORIG_VER_DIR="$PYENV_ROOT/versions/$VERSION_NAME"
	if test -e "$MIRROR_VER_DIR"; then {
		if mountpoint -q "$MIRROR_VER_DIR"; then {
			umount "$MIRROR_VER_DIR"
		}; fi
		rm -r "$MIRROR_VER_DIR"
		# rm "$ORIG_VER_DIR" && mkdir "$ORIG_VER_DIR";
	}; fi
	# } fi
}
after_uninstall "fake_cleanup"
