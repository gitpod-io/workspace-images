#!/bin/bash

###! This file is expected to process the required packages on the system and if either of them is not possible to be installed from disto -> Provide it manually

efixme() { [ "$IGNORE_FIXME" != 1 ] && printf 'FIXME: %s\n' "$1" ;}
eerror() { printf 'ERROR: %s\n' "$1" ;}
einfo() { printf 'INFO: %s\n' "$1" ;}
edebug() { [ "$DEBUG" = 1 ] && printf 'DEBUG: %s\n' "$1" ;}
die() {
	case "$1" in
		2) printf 'SYNERR: Argument %s was not recognized\n' "$2" ;;
		bug) printf "BUG: %s, please file a new issue in $UPSTREAM" "$2" ;;
		*) printf 'FATAL: %s\n' "$2" ;;
	esac

	exit "$1"
}
ebench() {
	# Allow skipping benchmark
	case "$SKIP_BENCHMARK" in 
		1) return 0 ;;
		*) die 23 "SAFETY-TRAP: Variable SKIP_BENCHMARK has unexpected value '$SKIP_BENCHMARK', expecting only '1' or blank"
	esac

	case "$1" in
		start)
			SECONDS=0
			return 0 ;;
		result)
			printf "BENCHMARK: Action %s took $SECONDS seconds\n" "$1"
			return 0 ;;
		*) die 2 "$1"
	esac

	die 23 "Logic in function 'ebench' escaped sanitization, safety trap!"
}

myName="installer"

# May not be needed
# # Check dependencies
# for cmd in git; do
# 	if command -v $cmd >/dev/null; then die 126 "$cmd"; fi
# done

# Define list of available packages to be used in logic
# FIXME: This should be defined in dockerfile so that it's not generating everytime myName is called
paludisList="$(cave print-packages)"
aptList="$(apt list)"
# FIXME: Implement prebuilt binaries for merge
binaryList=""

manuallInstall() {
	# In case we are able to merge in system using pre-compiled binary package
	if [ "$binaryList" = "$1" ]; then
		case "$1" in
			*) die bug "Package '$1' is not supported in binaryList which should never happend"
		esac
	fi

	# Linux From Source time
	# FIXME: Make sure that /usr/src/ is available to us (based on FSH3_0 it's optional directory which may not be present)
	case "$1" in
		nim)
			ebench start
			eerror "Script $myName was unable to process package $1 using upstream management, using manuall export"
			git clone https://github.com/nim-lang/Nim.git /usr/src/nim || exit 1
			cd /usr/src/nim || exit 1
			build_all.sh || die bug "upstream of package '$1' failed to provide working manuall management"
			ebench resutl "installing package '$1' LFS-style on '$DISTRO' with release '$DISTRO_RELEASE'"
		;;
		*) die fixme "Package '$1' is not supported for manuall installation assuming that it's not supported by upstream of $DISTRO/$DISTRO_RELEASE"
	esac
}

# Process packages from arguments
# NOTICE: -ge is used because '0' is shell
while [ "$#" -ge 1 ]; do case "$1" in
	nim)
		case "$DISTRO/$DISTRO_RELEASE" in
			"debian/stable"|"debian/testing"|"ubuntu/eoan")
				# Check if package is available
				ebench start
				if "$aptList" | grep -m 1 -q "^$1/$DISTRO_RELEASE.*"; then
					apt-get intall -y nim || manuallInstall "$1"
					ebench result "installing package '$1' on $DISTRO with release $DISTRO_RELEASE using distro's downstream"
				elif ! "$aptList" | grep -m 1 -q "^$1/$DISTRO_RELEASE.*"; then
					manuallInstall "$1"
				else
					die 255 "Processing $1 in $DISTRO/$DISTRO_RELEASE"
				fi
			;;
			exherbo/*)
				# Check if package is available
				if "$paludisList" | grep -m 1 -q "^sys-lang/$1-.*:.*::installed"; then
					apt-get intall -y nim || manuallInstall "$1"
				elif ! "$paludisList" | grep -m 1 -q "^sys-lang/$1-.*:.*::installed"; then
					manuallInstall "$1"
				else
					die 255 "Processing $1 in $DISTRO/$DISTRO_RELEASE"
				fi
			;;
		esac
		shift 1
	;;
	*) die 2 "$1"
esac; done