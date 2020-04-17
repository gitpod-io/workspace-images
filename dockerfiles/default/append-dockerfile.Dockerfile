
###! This is a dockerfile expecting to be appended to any docker core

# FIXME: Disable linting err
USER root

# Install all required packages
RUN true "sdhsfh" \
	thealer install \
	build-essentials \
	git \
	nano \
	vim \
	emacs \
	htop \
	less \
	zip \
	unzip \
	tar \
	rustc \
	cargo \
	openbox \
	python \
	python3 \
	pylint \
	shellcheck \
	golang \
	php \
	ruby \
	apache2 \
	nginx \
	apt-transport-https \