#!/bin/sh
# Created by Jacob Hrbek <kreyren@member.fsf.org> under GPLv3 <https://www.gnu.org/licenses/gpl-3.0.en.html> in 17/05/2020 based on informations from Zach Bjornson <zbbjornson@gmail.com> in https://github.com/Automattic/node-canvas/pull/1582#issuecomment-629837503 for TypeFox company maintaining gitpod <https://gitpod.io> and it's users

###! This is a hotfix for https://github.com/tomas/needle/issues/312 which is on Gitpod causing issue described https://github.com/gitpod-io/gitpod/issues/1520

# Required for docker-build to terminate correctly
set -e

# Identify script
myName="script gitpod-1520"

# Output handling
# FIXME-UPSTREAM: Implement standard (1st wave of krey's refactor)
einfo() { printf 'INFO: %s\n' "$1" ;}
ewarn() { printf 'WARNING: %s\n' "$1" ;}
eerror() { printf 'ERROR: %s\n' "$1" ;}
die() {
	case "$1" in
		0) printf 'SUCCESS: %s\n' "$2" ;;
		255) printf 'FATAL: Unexpected happend while %s\n' "$2" ;;
		[1-9] | [1-9][0-9] | 1[0-9][0-9] | 2[0-5][0-5] ) printf 'FATAL: %s\n' "$2" ;;
		*) printf 'WRONG_ARG(FATAL): %s\n' "$2"; exit 188
	esac

	exit "$1"
}
edebug() {
	if [ "$DEBUG" = 1 ]; then
		printf "DEBUG: %s\n" "$1"
	elif [ "$DEBUG" != 1 ]; then
		true
	else
		die 255 "Processing variable DEBUG with value '$DEBUG' in $myName"
	fi
}

# Root escalation - Not expected to run as non-root
if [ "$(id -u)" != 0 ]; then
	ewarn "$myName is expected to be invoked as root, but it has been executed from non-root! Trying to use sudo"
	SUDO="sudo"
elif [ "$(id -u)" = 0 ]; then
	unset SUDO
else
	die 255 "root escalation in $myName"
fi

einfo "Invoking $myName to workaround https://github.com/gitpod-io/gitpod/issues/1520"

# FIXME-UPSTREAM: Set for logic (Implemented in 3rd phase of Krey's refactor)
DISTRO="ubuntu"

# Sanitization for distro used
case "$DISTRO" in
	ubuntu) edebug "Expected distribution '$myName' has been parsed in $myName" ;;
	*) die 1 "Distribution '$DISTRO' is not supported by $myName"
esac

# Check if curl is available
if ! command -v curl 1>/dev/null; then
	case "$DISTRO" in
		ubuntu)
			einfo "$myName requires curl to read GitHub API to determine the logic which is not available on this environment, attempting to install it now.."
			# Do not double-quote, spaces are expected
			$SUDO apt install -y curl || die 1 "Unable to install curl which is required in $myName"
		;;
		*) die 0 "Distribution '$DISTRO' is not affected by https://github.com/gitpod-io/gitpod/issues/1520 to gitpod's knowledge"
	esac
elif command -v curl 1>/dev/null; then
	edebug "Command 'curl' is already available on this environment, no need to process it"
else
	die 255 "checking for curl in $myName"
fi

# Apply workaround for https://github.com/tomas/needle/issues/312 if the issue is not closed
bugStatus="$(curl https://api.github.com/repos/tomas/needle/issues/312 | grep -o "state.*")"
case "$bugStatus" in
	"state\": \"open\",")
		ewarn "Upstream bug https://github.com/tomas/needle/issues/312 is still open, applying workaround"

		case "$DISTRO" in
			ubuntu)
				if [ "$(apt list --installed node-pre-gyp | grep -o node-pre-gyp)" != "node-pre-gyp" ]; then
					$SUDO apt install -y node-pre-gyp || { eerror "$myName was unable to install package 'node-pre-gyp' which is required to install package 'canvas' using npm to workaround bug https://github.com/gitpod-io/gitpod/issues/1520 which is affected by https://github.com/tomas/needle/issues/312 as suggested in https://github.com/Automattic/node-canvas/pull/1582#issuecomment-629837503" ; exit 0 ;}
				elif [ "$(apt list --installed node-pre-gyp | grep -o node-pre-gyp)" = "node-pre-gyp" ]; then
					die 0 "Package 'node-pre-gyp' is already installed, no need to do anything.."
				else
					die 255 "resolving package 'node-pre-gyp' in $myName"
				fi
			;;
			*) einfo "Distribution '$DISTRO' is not affected by bug https://github.com/gitpod-io/gitpod/issues/1520, skipping.."
		esac
	;;
	"state\": \"closed\",")
		ewarn "The issue https://github.com/tomas/needle/issues/312 has been closed which deprecates $myName, please file an issue about this in $UPSTREAM or ideally remove $myName from gitpod's image"
		exit 0
	;;
	*)
		eerror "Unknown state '$bugStatus' of issue https://github.com/tomas/needle/issues/312 detected, please file a new issue about this in $UPSTREAM"
esac