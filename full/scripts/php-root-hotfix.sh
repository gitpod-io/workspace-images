#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> under GPLv3 license <https://www.gnu.org/licenses/gpl-3.0.html> in 01.05.2020

###! This is a hotfix for https://github.com/gitpod-io/gitpod/issues/943 that hotfixes https://github.com/gitpod-io/gitpod/issues/39 untill it's resolved
###! Abstract: chown -R root:gitpod /etc/php && chmod -R g+rw /etc/php

set -e

die() { printf 'FATAL: %s\n' "$2"; exit "$1" ;}
ewarn() { printf 'WARN: %s\n' "$1" ;}
einfo() { printf 'INFO: %s\n' "$1" ;}
eerror() { printf 'ERROR: %s\n' "$1" ;}

myName="php-root-hotfix"

[ "$(id -u)" != 0 ] && die 3 "Script '$myName' is not expected to run on non-root"

bugStatus="$(curl https://api.github.com/repos/gitpod-io/gitpod/issues/39 2>/dev/null | grep -o \"state.* | sed -E 's#(\"state\":\s{1}\")(.*)(\",)#\2#gm')"

# Apply patches
case "$bugStatus" in
	closed)
		einfo "Bug https://github.com/gitpod-io/gitpod/issues/39 has been closed, no need to apply hotfix for /etc/php" ;;
	open|*)
		# In case GitHub API is not reachable
		[ "$bugStatus" != open ] && eerror "Unexpected value '$bugStatus' has been parsed in script '$myScript'"
		chown -R root:gitpod /etc/php || eerror "Script '$myName' failed to set permission root:gitpod for directory /etc/php"
		chmod -R g+rw /etc/php || eerror "Script '$myName' failed to set permission g+rw for /etc/php"
esac