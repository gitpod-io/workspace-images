###! This is a dockerfile expecting to be added to any docker core

USER root

# Install all required packages
RUN thealer install \
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