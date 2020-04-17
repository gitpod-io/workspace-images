#!/bin/bash
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> under GPLv3 license <https://www.gnu.org/licenses/gpl-3.0.en.html> in 17/04/2020 05:57

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

# MAINTAINERS: Change this in case script name changes
myName="apt-mirror-benchmark"

[ ! -f /etc/os-release ] && die 1 "Script $myName expects file /etc/os-release"
# FIXME: Check if SPEEDTEST_TRIES is numerical
[ -z "$SPEEDTEST_TRIES" ] && die 1 "Script $myName requires variable SPEEDTEST_TRIES set on number of expected speedtests"

DISTRO="$(grep -o "^ID=.*" /etc/os-release)"

# Make sure that none is running this on unsupported distro
case "${DISTRO##ID=}" in
	debian)
		if ! command -v apt >/dev/null; then die 1 "This debian does not have expected apt, runtime is not adapted to handle this situation"; fi
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

if ! command -v netselect-apt >/dev/null; then
	apt install -y netselect-apt || die 1 "Unable to install package 'netselect-apt'"
	# Self-check
	if ! command -v netselect-apt >/dev/null; then die 1 "Self-check for availability of netselect-apt failed"; fi
elif command -v netselect-apt >/dev/null; then
	true
else
	die 255 "Unexpected happend while processing netselect-apt command"
fi

# Declare fastest mirrors
# NOTICE: Command 'netselect-apt' requires root otherwise it returns exit code 1
einfo "Testing for fastest mirrors.."
APT_STABLE_MIRROR="$(netselect-apt --nonfree --sources stable |& grep -A 1 "Of the hosts tested we choose the fastest valid for HTTP:" | grep -o "http://.*")"
APT_TESTING_MIRROR="$(netselect-apt --nonfree --sources testing |& grep -A 1 "Of the hosts tested we choose the fastest valid for HTTP:" | grep -o "http://.*")"
APT_SID_MIRROR="$(netselect-apt --nonfree --sources sid |& grep -A 1 "Of the hosts tested we choose the fastest valid for HTTP:" | grep -o "http://.*")"

# Self-check for mirrors
# NOTICE: netselect-apt may fail sometimes so we shoudn't be dieing here
[ -z "$APT_MIRROR_STABLE" ] && eerror "Script '$myName' failed to acquire fastest mirror for stable release" && APT_MIRROR_STABLE="$APT_MIRROR"
[ -z "$APT_TESTING_MIRROR" ] && eerror "Script '$myName' failed to acquire fastest mirror for testing release" && APT_TESTING_MIRROR="$APT_MIRROR"
[ -z "$APT_MIRROR_SID" ] && eerror "Script '$myName' failed to acquire fastest mirror for sid release" && APT_MIRROR_SID="$APT_MIRROR"

# Speedtest the found mirrors agains the one hardcoded in APT_MIRROR
tries=0
apt_mirror_speed=0
apt_mirror_stable_speed=0
apt_mirror_testing_speed=0
apt_mirror_sid_speed=0
while [ "$tries" != "$SPEEDTEST_TRIES" ]; do
	# shellcheck disable=SC1083 # Invalid, part of syntax -- (This } is literal. Check expression (missing ;/\n?) or quote)
	apt_mirror_speed+="$(curl --write-out %{speed_download} "$APT_MIRROR/debian/README" --output /dev/null 2>/dev/null)"
	# shellcheck disable=SC1083 # Invalid, part of syntax -- (This } is literal. Check expression (missing ;/\n?) or quote)
	apt_mirror_stable_speed+="$(curl --write-out %{speed_download} "$APT_MIRROR_STABLE/debian/README" --output /dev/null 2>/dev/null)"
	# shellcheck disable=SC1083 # Invalid, part of syntax -- (This } is literal. Check expression (missing ;/\n?) or quote)
	apt_mirror_testing_speed+="$(curl --write-out %{speed_download} "$APT_MIRROR_TESTING/debian/README" --output /dev/null 2>/dev/null)"
	# shellcheck disable=SC1083 # Invalid, part of syntax -- (This } is literal. Check expression (missing ;/\n?) or quote)
	apt_mirror_sid_speed+="$(curl --write-out %{speed_download} "$APT_MIRROR_SID/debian/README" --output /dev/null 2>/dev/null)"

	tries="$(( "$tries" + 1 ))"
done

# Get average of network speed
# NOTICE: Do not use '$(( ))', because that does not know how to process decimals
apt_mirror_speed=$(bc -q <<< "$apt_mirror_speed / $SPEEDTEST_TRIES")
apt_mirror_stable_speed=$(bc -q <<< "$apt_mirror_stable_speed / $SPEEDTEST_TRIES")
apt_mirror_testing_speed=$(bc -q <<< "$apt_mirror_testing_speed / $SPEEDTEST_TRIES")
apt_mirror_sid_speed=$(bc -q <<< "$apt_mirror_sid_speed / $SPEEDTEST_TRIES")

# Prefer hardcodded if faster
[ "$apt_mirror_speed" -le "$apt_mirror_stable_speed" ] && APT_MIRROR_STABLE="$APT_MIRROR"
[ "$apt_mirror_speed" -le "$apt_mirror_testing_speed" ] && APT_MIRROR_TESTING="$APT_MIRROR"
[ "$apt_mirror_speed" -le "$apt_mirror_sid_speed" ] && APT_MIRROR_SID="$APT_MIRROR"

# CORE
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
> /etc/apt/sources.list