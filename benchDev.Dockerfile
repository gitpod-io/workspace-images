FROM debian:stable

###! Additional info:
###! - Do not use sudo -> Set proper group permission
###! - Set variable SPEEDTEST_TRIES on the integer of expected speedtests
###!   - More tries -> More accurate result
###!   - Recommended value: 5
###! - Set variable APT_MIRROR on hard-codded mirror (stub in case gitpod will provide it's own mirror), speedtest will be performed anyway to verify that hardcoded mirror is faster then alternatives

LABEL Gitpod Maintainers

# To avoid bricked workspaces assuming interactive shell breaks the build (https://github.com/gitpod-io/gitpod/issues/1171)
# NOTICE(Kreyren): double quotes are not needed here, but i think it looks nicer
ENV DEBIAN_FRONTEND="noninteractive"

# FIXME: We should allow end-users to set this
ENV LANG="en_US.UTF-8"
ENV LC_ALL="C"

# Set on the number of expected speedtests performed
# - Use 'disabled' to skip speedtests, not-recommended!
ENV SPEEDTEST_TRIES="5"

USER root

# Add 'gitpod' user
RUN useradd \
	--uid 33333 \
	--create-home --home-dir /home/gitpod \
	# NOTICE: We allow end-users to set their own shell, but bash is used by default
	--shell /bin/bash \
	--password gitpod \
	gitpod

# Grab bare minimum that we need for configuration
# NOTICE: You can use `gpg --search-keys` to get the recv-keys value, this requires upstream to upload in relevant keyserver and sync them
# NOTICE: Do not use debian/ubuntu keyserver (https://unix.stackexchange.com/questions/530778/what-is-debians-default-gpg-keyserver-and-where-is-it-configured) -> Use keys.opengpg.org which also sets standard for keyserver instead of fregmenting
ENV APT_MIRROR="http://mirror.dkm.cz/debian"
RUN printf '%s\n' \
		"# Stable" \
		"deb $APT_MIRROR stable main non-free contrib" \
		"deb-src $APT_MIRROR stable main non-free contrib" \
	> /etc/apt/sources.list \
	&& apt-get update \
	# NOTICE: We need apt-utils later for package configuration
	 && apt-get install -y gnupg wget apt-utils netselect-apt

# Initial configuration
# FIXME: Ideally this shoudn't be cached to avoid grabbing dead mirror
COPY core/scripts/apt-mirror-benchmark.bash /usr/bin/apt-mirror-benchmark
RUN true "dsdhfd" \
	&& chmod +x /usr/bin/apt-mirror-benchmark \
	&& /usr/bin/apt-mirror-benchmark \
	&& rm /usr/bin/apt-mirror-benchmark \
	&& printf '%s\n' \
		"# WINE" \
		"deb [arch=amd64,i386] https://dl.winehq.org/wine-builds/debian/ bullseye main" \
		"deb-src [arch=amd64,i386] https://dl.winehq.org/wine-builds/debian/ bullseye  main" \
	>> /etc/apt/sources.list