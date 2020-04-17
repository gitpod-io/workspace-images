#!/bin/bash

###! This script is designed to benchmark all available mirrors and then pick the fastest to configure /etc/apt/sources.list
###! Abstract:
###! - Use `netselect-apt --nonfree --sources stable |& grep -A 1 "Of the hosts tested we choose the fastest valid for HTTP:" | grep -o "http://.*"` to get the fastest mirror -> Configure /etc/apt/sources.list with it

# FIXME: Add translations

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

exit 28

# MAINTAINERS: Change this in case script name changes
myName="apt-mirror-benchmark"

[ ! -f /etc/os-release ] && die 1 "Script $myName expects file /etc/os-release"

DISTRO="$(grep -o "ID=.*" /etc/os-release)"

# Make sure that none is running this on unsupported distro
case "${DISTRO##ID=}" in
	debian)
		if ! command -v apt; then die 1 "This debian does not have expected apt, runtime is not adapted to handle this situation"; fi
	;;
	*) die 1 "Distribution '$DISTRO' is not supported by $myName script"
esac

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

# Declare fastest mirrors
# NOTICE: Command 'netselect-apt' requires root otherwise it returns exit code 1
APT_STABLE_MIRROR="$("$SUDO" netselect-apt --nonfree --sources stable |& grep -A 1 "Of the hosts tested we choose the fastest valid for HTTP:" | grep -o "http://.*")"
APT_TESTING_MIRROR="$("$SUDO" netselect-apt --nonfree --sources testing |& grep -A 1 "Of the hosts tested we choose the fastest valid for HTTP:" | grep -o "http://.*")"
APT_SID_MIRROR="$("$SUDO" netselect-apt --nonfree --sources sid |& grep -A 1 "Of the hosts tested we choose the fastest valid for HTTP:" | grep -o "http://.*")"

# Self-check for mirrors
[ -z "$APT_MIRROR_STABLE" ] && die 1 "Script '$myName' failed to acquire fastest mirror for stable release"
[ -z "$APT_TESTING_MIRROR" ] && die 1 "Script '$myName' failed to acquire fastest mirror for testing release"
[ -z "$APT_MIRROR_SID" ] && die 1 "Script '$myName' failed to acquire fastest mirror for sid release"

# CORE
"$SUDO" su root -c printf '%s\n' \
	"# Stable" \
	"deb $APT_STABLE_MIRROR stable main non-free contrib" \
	"deb-src $APT_STABLE_MIRROR stable main non-free contrib" \
	"# Testing" \
	"deb $APT_TESTING_MIRROR testing main non-free contrib" \
	"deb-src $APT_TESTING_MIRROR testing main non-free contrib" \
	"# SID" \
	"deb $APT_SID_MIRROR testing main non-free contrib" \
	"deb-src $APT_SID_MIRROR testing main non-free contrib" \
> /etc/apt/sources.list