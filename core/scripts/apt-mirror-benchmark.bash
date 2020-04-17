#!/bin/bash

###! This script is designed to benchmark all available mirrors and then pick the fastest to configure /etc/apt/sources.list
###! Abstract:
###! - Use `netselect-apt --nonfree --sources stable |& grep -A 1 "Of the hosts tested we choose the fastest valid for HTTP:" | grep -o "http://.*"` to get the fastest mirror -> Configure /etc/apt/sources.list with it

efixme() { printf 'FIXME: %s\n' "$1" ;}
eerror() { printf 'ERROR: %s\n' "$1" ;}
einfo() { printf 'INFO: %s\n' "$1" ;}
edebug() { [ "$IGNORE_FIXME" != 1 ] && printf 'DEBUG: %s\n' "$1" ;}
die() {
	case "$1" in
		2) printf 'SYNERR: %s\n' "Argument '$2' was not recognized" ;;
		*) printf 'FATAL: %s\n' "$2" ;;
	esac

	exit "$1"
}

# Ensure that we have the required permission
if [ "$(id -u)" != 0 ]; then
	if command -v sudo; then
		export SUDO="sudo"
	elif ! command -v sudo; then
		die 1 "Unable to acquire root permission"
	else
		die 255 "Unexpected happend while trying to acquire root using sudo"
	fi
elif [ "$(id -u)" = 0 ]; then
	unset SUDO
else
	die 255 "Unexpected happend while checking user with id '$(id -u)'"
fi

if ! command -v netselect-apt; then
	"$SUDO" apt install -y netselect-apt || die 1 "Unable to install package 'netselect-apt'"
	# Self-check
	if ! command -v netselect-apt; then die 1 "Self-check for availability of netselect-apt failed"; fi
elif ! command -v netselect-apt; then
	true
else
	die 255 "Unexpected happend while processing netselect-apt command"
fi

export APT_STABLE_MIRROR="$(netselect-apt --nonfree --sources stable |& grep -A 1 "Of the hosts tested we choose the fastest valid for HTTP:" | grep -o "http://.*")"
export APT_TESTING_MIRROR="$(netselect-apt --nonfree --sources testing |& grep -A 1 "Of the hosts tested we choose the fastest valid for HTTP:" | grep -o "http://.*")"
export APT_SID_MIRROR="$(netselect-apt --nonfree --sources sid |& grep -A 1 "Of the hosts tested we choose the fastest valid for HTTP:" | grep -o "http://.*")"

printf '%s\n' \
	"# Stable" \
	"deb $APT_STABLE_MIRROR stable main non-free contrib" \
	"deb-src $APT_STABLE_MIRROR stable main non-free contrib" \
	"# Testing" \
	"deb $APT_TESTING_MIRROR testing main non-free contrib" \
	"deb-src $APT_TESTING_MIRROR testing main non-free contrib" \
	"# SID" \
	"deb $APT_SID_MIRROR testing main non-free contrib" \
	"deb-src $APT_SID_MIRROR testing main non-free contrib" \
