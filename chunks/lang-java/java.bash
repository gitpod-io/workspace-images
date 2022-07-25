#!/usr/bin/env bash

# Only perform the below actions inside a live workspace session.
# Because /workspace dir does not exist for `#imagebuild` environment over custom dockerfiles.
if test -e "$GITPOD_REPO_ROOT"; then {
	jsettings_string='<localRepository>/workspace/m2-repository/</localRepository>'
	jsettings_file="$HOME/.m2/settings.xml"
	if ! grep -q "$jsettings_string" "$jsettings_file" 2>/dev/null; then {
		printf '<settings>\n  %s\n</settings>\n' "$jsettings_string" >"$jsettings_file"
	}; fi
	unset jsettings_string jsettings_file
	export GRADLE_USER_HOME=/workspace/.gradle
}; fi

export SDKMAN_DIR="$HOME/.sdkman"
sdkman_init="$SDKMAN_DIR/bin/sdkman-init.sh"
if test -s "$sdkman_init"; then {
	# shellcheck source=/dev/null
	source "$sdkman_init"
}; else {
	echo "error: $sdkman_init is corrupted"
}; fi
unset sdkman_init
