#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> under GPLv3 license <https://www.gnu.org/licenses/gpl-3.0.html> in 01.05.2020

###! This is a hotfix for https://github.com/gitpod-io/gitpod/issues/943 that hotfixes https://github.com/gitpod-io/gitpod/issues/39 untill it's resolved, expected to run in docker-build environment only
###! Abstract: chown -R root:gitpod /etc/php && chmod -R g+rw /etc/php

set -e # Docker won't exit if this is not specified

die() { printf 'FATAL: %s\n' "$2"; exit "$1" ;}
ewarn() { printf 'WARN: %s\n' "$1" ;}
einfo() { printf 'INFO: %s\n' "$1" ;}
eerror() { printf 'ERROR: %s\n' "$1" ;}

myName="php-root-hotfix"
targetDir="/etc/php"


# FIXME: Make sure that this is running in docker-build

# Do not run on non-root
if [ "$(id -u)" = 0 ]; then
	unset SUDO # Make sure that sudo is not used
if [ "$(id -u)" != 0 ]; then
	# Attempt to elevate root
	if command -v sudo >/dev/null; then
		SUDO="sudo"
	elif ! command -v sudo >/dev/null; then
		die 3 "Unable to elevate permission since script '$myName' is runninng on non-root without sudo"
	else
		die 255 "Script '$myName' checking for methods to elevate root"
	fi
else
	die 255 "Unexpected happend while processing root permission in script '$myName'"
fi

# Get bug status from GitHub API
bugStatus="$(curl https://api.github.com/repos/gitpod-io/gitpod/issues/39 2>/dev/null | grep -o \"state.* | sed -E 's#(\"state\":\s{1}\")(.*)(\",)#\2#gm')"

# Check for targetDir
if [ -d "$targetDir" ]; then
	true
elif [ ! -d "$targetDir" ]; then
	die 0 "Expected directory '$targetDir' is not present on this environment, no need to apply hotfix for bug https://github.com/gitpod-io/gitpod/issues/39"
else
	die 255 "Checking for '$targetDir' in script '$myName'"
fi

# Apply patches
case "$bugStatus" in
	closed)
		einfo "Bug https://github.com/gitpod-io/gitpod/issues/39 has been closed, no need to apply hotfix for $targetDir" ;;
	open|*)
		# In case GitHub API is not reachable
		# BugStatus variable could output spam, using '${var#???..}' to limit the lenght
		[ "$bugStatus" != open ] && eerror "Unexpected value '${bugStatus#???????????}' has been parsed in script '$myScript'"

		# CORE
		chown -R root:gitpod "$targetDir" || eerror "Script '$myName' failed to set permission root:gitpod for directory $targetDir"
		chmod -R g+rw "$targetDir" || eerror "Script '$myName' failed to set permission g+rw for $targetDir"
esac