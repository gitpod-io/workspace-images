#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> under license GPL-3 (https://www.gnu.org/licenses/gpl-3.0.en.html)
# Based in part on https://github.com/JesterOrNot/Gitpod-V which is created by Sean Hellum as unlicense

: "
Initialization script made for gitpod to install vlang backend in gitpod

This script is developed to be POSIX-compatible

CONFIGURATION
- $VLANG_SOURCE = Path used for extraction and keeping of vlang source files
- $VLANG_VERSION = Expected vlang version (value 'latest' is supported through GitHub API)
- $VLANG_GROUP = Group used for those that are expected to have access in vlang
- $CACHEDIR = Path for cache directory, based on FSH3.0 (270120) this should be '$HOME/.cache'
- $VLANG_EXE = Path to which we will extract executable for vlang
"

# Configuration
[ -z "$VLANG_SOURCE" ] && VLANG_SOURCE="/opt/vlang"
[ -z "$VLANG_VERSION" ] && VLANG_VERSION="0.1.24"
[ -z "$VLANG_GROUP" ] && VLANG_GROUP="vlang"
[ -z "$CACHEDIR" ] && CACHEDIR="$HOME/.cache"
[ -z "$VLANG_EXE" ] && VLANG_EXE="/usr/bin/v"

# Simplified die for assertion
die() {
	DIE_PREFIX="FATAL:"
	printf "$DIE_PREFIX %s\\n" "$2"
	unset VLANG_SOURCE VLANG_VERSION DIE_PREFIX CACHEDIR VLANG_EXE
	exit "$1"
}

edebug() {
	DEBUG_PREFIX="DEBUG:"
	[ -n "$DEBUG" ] && printf "$DEBUG_PREFIX %s\\n" "$1"
}

# checkroot
if [ "$(id -u)" != "0" ]; then
	die 3 "Insufficient permission UID '$(id -u)' user '$USER' for vlang initialization"
elif [ "$(id -u)" = "0" ]; then
	edebug "Script has been executed from expected user '$USER' with UID '$(id -u)'"
else
	die 256 "Unexpected happend while checking root"
fi

# Define latest version
case "$VLANG_VERSION" in
	[0-9].[0-9].[0-9]|[0-9][0-9].[0-9].[0-9]|[0-9][0-9].[0-9][0-9].[0-9]|[0-9][0-9].[0-9][0-9].[0-9][0-9]|[0-9].[0-9][0-9].[0-9]|[0-9].[0-9].[0-9][0-9]) true ;;
	latest)
		VLANG_VERSION="$(curl https://api.github.com/repos/vlang/v/releases/latest 2>/dev/null | grep tag_name | sed '/^[[:blank:]]*"tag_name":[[:blank:]]*"\([^"]*\)",[[:blank:]]*$/!d; s//\1/; q' || die 4 "Unable to get latest vlang version for GitHub API")" ;;
	*) die 2 "Unsupported vlang version '$VLANG_VERSION' has been parsed in vlang_init script"
esac

# Create cachedir
if [ ! -d "$CACHEDIR" ]; then
	mkdir "$CACHEDIR" || die 1 "Unable to make a new directory in '$HOME/.cache' used for caching"
	edebug "Created a new directory in '$CACHEDIR' used for caching"
elif [ -d "$CACHEDIR" ]; then
	edebug "Directory '$CACHEDIR' already exits, skipping creation"
else
	die 256 "Unexpected happend while creating chachedir, bug?"
fi

# Fetch
if [ ! -f "$CACHEDIR/vlang-$VLANG_VERSION.zip" ]; then
	wget "https://github.com/vlang/v/releases/download/$VLANG_VERSION/v_linux.zip" -O "$CACHEDIR/vlang-$VLANG_VERSION.zip" || die 1 "Unable to fetch vlang tarball"
	edebug "Vlang source tarball has been exported in '$CACHEDIR/vlang-$VLANG_VERSION.zip'"
elif [ -f "$CACHEDIR/vlang-$VLANG_VERSION.zip" ]; then
	edebug "File '$CACHEDIR/vlang-$VLANG_VERSION.zip' already exists, skipping fetch"
else
	die 256 "Unexpected happend while fetching vlang source tarball in '$CACHEDIR/vlang-$VLANG_VERSION'"
fi

# Create a new directory used for source files
if [ ! -d "$VLANG_SOURCE" ]; then
	mkdir "$VLANG_SOURCE" || die 1 "Unable to create a new directory for source extraction of vlang"
	edebug "Created a new directory in '$VLANG_SOURCE' used for vlang source files"
elif [ -d "$VLANG_SOURCE" ]; then
	edebug "Directory in '$VLANG_SOURCE' is already present, skipping creation"
else
	die 256 "Unexpected happend while creating a new directory in '$VLANG_SOURCE'"
fi

# Extract
if [ ! -f "$VLANG_SOURCE/Makefile" ]; then
	unzip "$CACHEDIR/vlang-$VLANG_VERSION.zip" -d "$VLANG_SOURCE" || die 1 "Unable to extract vlang source in '$VLANG_SOURCE' directory"
	edebug "vlang source files has been extracted in '$VLANG_SOURCE'"
elif [ -f "$VLANG_SOURCE/Makefile" ]; then
	edebug "vlang source files are already extracted, skipping extract"
else
	die 256 "Unexpected happend while extracting vlang source files"
fi

# Compile
if [ ! -f "$VLANG_SOURCE/v" ]; then
	make -C "$VLANG_SOURCE" || die 1 "This system is unable to compile vlang"
	edebug "vlang has been sucessfully compiled"
elif [ -f "$VLANG_SOURCE/v" ]; then
	edebug "vlang is already compiled, skipping compilation"
else
	die 256 "Unexpected happend while compiling vlang source files"
fi

# Export executable
if [ ! -h "$VLANG_EXE" ] && [ ! -f "$VLANG_EXE" ]; then
	ln -sf "$VLANG_SOURCE/v" "$VLANG_EXE" || die 1 "Unable to symlink vlang executable in '$VLANG_EXE'"
	edebug "Vlang executable has been sucessfully symlinked"
elif [ -f "$VLANG_EXE" ]; then
	die 1 "Pathname '$VLANG_EXE' is a file where symlink to compiled vlang compiler is expected"
elif [ -h "$VLANG_EXE" ]; then
	edebug "Vlang executable is already symlinked, skipping.."
fi

# Create a new user-group for vlang users
if ! grep -qF vlang /etc/passwd 2>/dev/null; then
	groupadd vlang || die 1 "Unable to make a new user-group 'vlang'"
	edebug "Created a new user-group 'vlang'"
elif grep -qF vlang /etc/passwd 2>/dev/null; then
	edebug "User-group 'vlang' already exists, skipping creation"
else
	die 256 "Unexpected happend while creating new user-group 'vlang'"
fi

# Transfer ownership of VLANG_SOURCE to vlang user-group
if [ "$(stat -c '%G' "$VLANG_SOURCE")" != vlang ]; then
	chown -R root:vlang "$VLANG_SOURCE" || die 1 "Unable to transfer ownership of '$VLANG_SOURCE' directory to vlang user-group"
	edebug "Permission to '$VLANG_SOURCE' directory has been transfered to vlang user-group"
elif [ "$(stat -c '%G' "$VLANG_SOURCE")" = vlang ]; then
	edebug "Directory '$VLANG_SOURCE' is already owned by 'vlang' user-group"
else
	die 256 "Unexpected happend while transfering '$VLANG_SOURCE' directory to 'vlang' user-group"
fi

# Add gitpod user in vlang group
if ! groups | grep -qF "$VLANG_GROUP"; then
	usermod -a -G "$VLANG_GROUP" gitpod || die 1 "Unable to transfer user 'gitpod' in user-group '$VLANG_GROUP'"
	edebug "User 'gitpod' has been added in user-group '$VLANG_GROUP'"
elif groups | grep -qF $VLANG_GROUP; then
	edebug "User 'gitpod' is already in user-group '$VLANG_GROUP'"
else
	die 256 "Unexpected happend while adding user 'gitpod' in user-group '$VLANG_GROUP'"
fi

# Selfcheck
su gitpod -c "$VLANG_EXE" help 1>/dev/null || die 1 "Self-check for Vlang failed"

# Master unset
unset VLANG_SOURCE VLANG_VERSION DIE_PREFIX CACHEDIR VLANG_EXE