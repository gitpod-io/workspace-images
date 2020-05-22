#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> under GPLv3 <https://www.gnu.org/licenses/gpl-3.0.en.html> in 22/05/2020

###! Script to resolve a hadolint on target docker-based environment
###! As of 22/05/2020 ubuntu does not provide hadolint in their downstream (https://packages.ubuntu.com/search?keywords=hadolint&searchon=names&suite=eoan&section=all)
###! Do not double-quote SUDO variable prefix

# Command overrides
[ -z "$PRINTF" ] && PRINTF="printf"
[ -z "$WGET" ] && WGET="wget"
[ -z "$CURL" ] && CURL="curl"
[ -z "$ARIA2C" ] && ARIA2C="aria2c"
[ -z "$CHMOD" ] && CHMOD="chmod"

set -e

# MAINTAINERS: In case repository name changes this should be updated
myName="Script hadolint in gitpod/workspace-images"
# NOTICE(Krey): We are starting the log in homedir in case the script is executed on non-root, when we confirm a root available then we move it in relevant dir
logPath="$HOME/.$("$PRINTF" '%s\n' "$myName" | tr ' ' '-' | tr '/' '-').log"
# Format of the date in the logs, uses ISO 8601 by default
dateFormat=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
logPrefix="[ $dateFormat ] "

# Inicialization of the script in the log
"$PRINTF" "$logPrefix%s\n" "Inicialized $myName on " >> "$logPath"

einfo() {
	"$PRINTF" 'INFO: %s\n' "$1"
	"$PRINTF" "${logPrefix}INFO: %s\\n" "$1" >> "$logPath"
}
ewarn() {
	"$PRINTF" 'WARNING: %s\n' "$1"
	"$PRINTF" "${logPrefix}WARN: %s\\n" "$1" >> "$logPath"
}
eerror() {
	"$PRINTF" 'ERROR: %s\n' "$1"
	"$PRINTF" "${logPrefix}ERR: %s\\n" "$1" >> "$logPath"
}
die() {
	case "$1" in
		1)
			"$PRINTF" 'FATAL: %s\n' "$2"
			"$PRINTF" "${logPrefix}DIE: %s\\n" "$1" >> "$logPath"
		;;
		255)
			case "$LANG" in
				cz-*)
					"$PRINTF" 'FATAL: Neočekávané se stalo během %s\n' "$2"
					"$PRINTF" "${logPrefix}DIE: Neočekávané se stalo během %s\\n" "$1" >> "$logPath" ;;
				en-*|*)
					"$PRINTF" 'FATAL: Unexpected happend while %s\n' "$2"
					"$PRINTF" "${logPrefix}DIE: Unexpected happend while %s\\n" "$1" >> "$logPath"
			esac
	esac

	exit "$1"
}
edebug() {
	if [ "$DEBUG" = 1 ]; then
		"$PRINTF" 'DEBUG: %s\n' "$1"
		"$PRINTF" "${logPrefix}DBG: %s\\n" "$1" >> "$logPath"
	elif [ "$DEBUG" = 0 ] || [ -z "$DEBUG" ]; then
		true
	else
		die 255 "processing DEBUG variable in edebug function"
	fi
}

###! Wrapper for downloading files
###! SYNOPSIS: dwnl [url] [TargetLocation]
dwnl() {
	if command -v wget 1>/dev/null; then
		"$WGET" "$1" -O "$2" || die 1 "Function dwnl() in $myName was unable to download '$1' in '$2' using wget"
	elif command -v curl 1>/dev/null; then
		"$CURL" -o "$2" "$1" || die 1 "Function dwnl() in $myName was unable to download '$1' in '$2' using curl"
	elif command -v aria2c 1>/dev/null; then
		"$ARIA2C" -o "$2" "$1"
	elif ! command -v wget 1>/dev/null && ! command -v curl 1>/dev/null && ! command -v aria2c 1>/dev/null; then
		ewarn "Neither of support downloaders are present in this environment, trying to resolve.."

		case "$KERNEL" in
			Linux) 
				case "$DISTRO" in
					ubuntu|debian)
						# Fallback to wget
						if ! apt list wget | grep -q "^wget -"; then
							$SUDO apt-get update || die 1 "Unable to fetch repositories for kernel '$KERNEL' using distro '$DISTRO'"

							$SUDO apt-get install -y wget || die 1 "Unable to install wget on kernel '$KERNEL' using distro '$DISTRO'"

							# Self-check
							if ! command -v wget 1>/dev/null; then
								die 38 "self-check failed for command wget in function dwnl() called from $myName"
							elif command -v wget 1>/dev/null; then
								edebug "Self-check passed for command wget in function dwnl() called from $myName"
							else
								die 255 "self-checking wget in function dwnl() called from $myName"
							fi
						fi ;;
					*) die 1 "Unsupported DISTRO '$DISTRO' has been parsed in function dwnl() called from $myName, fixme?"
					;;
				esac ;;
			*) die 1 "Unsupporter kernel '$KERNEL' has been parsed in $myName function dwnl(), fixme?"
		esac
		
	fi
}

# Check root
if [ "$(id -u)" = 0 ]; then
	edebug "Confirmed user with id '$(id -u)' (root)"
	unset SUDO
elif [ "$(id -u)" = 1000 ]; then
	edebug "Confirmed user with id '$(id -u)' (non-root)"
	ewarn "We are not expecting non-root to be using this script, trying to elevate.."
	if command -v sudo 1>/dev/null; then
		SUDO="sudo"
	elif ! command -v sudo 1>/dev/null; then
		die 3 "We are unable to elevate root on this environment"
	else
		die 255 "elevating root in $myName"
	fi
else
	die 255 "checking for root in $myName of user with id '$(id -u)'"
fi

# Identify distro
if [ -f "/etc/os-release" ] && command -v lsb_release 1>/dev/null; then
	fileRelease="$(grep -o "^ID\=.*" /etc/os-release | sed 's#ID\=##gm')"
	cmdRelease="$(lsb_release -si | tr '[:upper:]' '[:lower:]')"

	if [ "$cmdRelease" != "$fileRelease" ]; then
		ewarn "ID property in /etc/os-release '$fileRelease' does not match with output from command 'lsb_release -si' which is '$cmdRelease'"
		DISTRO="$fileRelease"
	elif [ "$cmdRelease" != "$fileRelease" ]; then
		DISTRO="$fileRelease"
	fi

elif [ -f "/etc/os-release" ] && ! command -v lsb_release 1>/dev/null; then
	DISTRO="$(grep -o "^ID\=.*" /etc/os-release | sed 's#ID\=##gm')"
elif [ ! -f "/etc/os-release" ] && command -v lsb_release 1>/dev/null; then
	DISTRO="$(lsb_release -si | tr '[:upper:]' '[:lower:]')"
fi

# Identify kernel
KERNEL="$(uname -s)"

# Get hadolint
case "$KERNEL" in
	Linux)
		case "$DISTRO" in
			ubuntu|debian)
				if ! command -v hadolint 1>/dev/null; then
					# Check if we can install hadolint
					if ! apt list hadolint | grep -q "^hadolint -"; then
						$SUDO apt-get update || die 1 "Unable to update repositories on $DISTRO using kernel $KERNEL in $myName"

						# Check if hadolint is available in apt repositories
						if ! apt-cache search hadolint | grep -q "^hadolint -"; then
							ewarn "Package hadolint is not available in downstream of distro '$DISTRO' on kernel '$KERNEL' after executing 'apt-get update', trying to resolve by installing it manually.."

							# FIXME: Implement dwnl
							dwnl https://github.com/hadolint/hadolint/releases/download/v1.17.5/hadolint-Linux-x86_64 /usr/bin/hadolint

							if [ ! -x /usr/bin/hadolint ]; then
								$SUDO "$CHMOD" +x /usr/bin/hadolint || die 1 "Unable to set executable permission /usr/bin/hadolint"
							elif [ -x /usr/bin/hadolint ]; then
								ewarn "Binary of hadolint has been downloaded with executable permission, which is a unexpected"
							else
								die 255 "Setting executable permission for hadolint in $myName"
							fi
						elif apt list hadolint | grep -q "^hadolint -"; then
							edebug "Package hadolint has been confirmed to be available on $DISTRO in this environment"
							apt-get install -y hadolint || die 1 "Apt failed to install hadolint in $myName on distribution $DISTRO using kernel $KERNEL"
						else
							die 255 "checking for hadolint in $myName"
						fi

						# Self-check
						if command -v hadolint 1>/dev/null; then
							edebug "hadolint passed self-check in $myName"
						elif ! command -v hadolint 1>/dev/null; then
							die 38 "Hadolint did not pass self-check in $myName"
						else
							die 255 "self-checking hadolint in $myName on kernel '$KERNEL' using distro '$DISTRO'"
						fi
					fi
				fi
			;;
			*) die 1 "Unsupported distribution '$DISTRO' has been parsed in $myName, fixme?"
		esac
	;;
	"") die 1 "Command 'uname -s' failed to identify kernel on this environment" ;;
	*) die 255 "Unexpected kernel '$(uname -s)' has been parsed in $myName"
esac