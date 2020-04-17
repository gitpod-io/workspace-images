#!/bin/bash

# Created by Jacob Hrbek <kreyren@rixotstudio.cz> under GPLv3 license <https://www.gnu.org/licenses/gpl-3.0.en.html> in 2020/04/16 - 09:00

###! This script process expected shell and sets it for the end-user
###! Abstract:
###! - Set login shell based on value of expectedShell variable
###! - Install required dependencies for said shell
###! Aditional info:
###! - Currently we are using usermod to set login shell, alternatives are:
###!   - `chsh "$(command -v "$expectedShell")"`, see `chsh -l` for available shells
###! - See `/etc/shels` for available shells
###! - We are not using `apt update` and alternative commands per distro, because this is expected to be handled by "Gitpod Dockerfile Core"

die() { printf 'FATAL: %s\n' "$2"; exit "$1";}

# Make sure we are running on root
[ "$(id -u)" != 0 ] && die 3 "Unexpected user with ID '$(id -u)' invoked script shellConfig, expecting root user"

# FIXME: Shoudn't be fatal
[ ! -e "/etc/os-release" ] && die 1 "Expected file '/etc/os-release' is not available, unable to process shell"

DISTRO="$(grep -o "ID=.*" /etc/os-release)"
	DISTRO="${DISTRO##ID\=}" # Strip `ID=`

# shellcheck disable=SC2154 # Expected to be set in dockerfile
case "$expectedShell" in
			bash|"")
				[ -z "$expectedShell" ] && eerror "We are expecting variable expectedShell set on shell that we are expecting in production system, since it's blank we are using default bash"
				case "$DISTRO" in
					debian|ubuntu) apt install -y bash-completion || die 1 "Unable to install bash-completion" ;;
					# FIXME: Obvious
					gentoo) die 1 "Gentoo required bash-completion use-flag enabled" ;;
					# FIXME: Obvious
					exherbo) die 1 "Exherbo required bash-completion option enabled" ;;
					# FIXME: Obvious
					archlinux) die 1 "Kreyren: I have no idea what arch wants to get bash-completion" ;;
					*) die 255 "Unsupported distro '$DISTRO' has been parsed in shellConfig script"
				esac
			;;
			sh|dash) true ;; # nothing else to do here atm
			powershell)
				case "$DISTRO" in
					debian|ubuntu) apt install -y powershell || die 1 "Unable to install powershell" ;;
					# Gentoo requires pentoo repository, see http://gpo.zugaina.org/dev-lang/powershell-bin
					gentoo) emerge -vuDNj dev-lang/powershell-bin || die 1 "Unable to install powershell-bin package on gentoo" ;;
					exherbo) die 1 "Exherbo does not have package for powershell, if anyone really wants it make an issue and mension @kreyren and i implement it for you" ;;
				esac
			;;
			*) die 255 "Unexpected shell in variable expectedShell with value '$expectedShell' has been provided to shellConfig script"
esac

# Set login shell
usermod --shell "$expectedShell" gitpod || die 1 "Unable to set login shell on '$expectedShell'"