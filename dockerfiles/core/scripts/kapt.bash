#!/bin/bash

###! This script is made specifically for systems that does not have root, but expect to use apt's full functionality
###! Rationale:
###! - Proper group management is not an option assuming that apt keeps trying to make a new files with 'root:root' even when we expect 'root:apt' alike 'https://github.com/gitpod-io/workspace-images/pull/204/commits/3482a0c5262bce0aa38f81c28824978a47a1d404'
###! Theory:
###! - We are making a new FSH as a makeshift sandbox in a place accesible by the non-root to which we make custom file system hierarchy and force apt to use it as a new root using configuration from /etc/apt on host
###! Additional info
###! - See `man apt.conf` and `apt-config dump`
###! - deboostrap may help to create the initial filesystem

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

# Root trap
[ "$(id -u)" = 0 ] && die 3 "This script is not expected to be executed on root"

# Argument management
while [ "$#" -ge 1 ]; do case "$1" in
	"update")
		apt-get -o Dir="$HOME/makeshift/" install -y debootstrap
		apt --root="$HOME/makeshift/" "$1"
		shift 1
	;;
	--help|help) efixme "help-message" ;;
	*) die 2 "$1"
esac; done