FROM gitpod/workspace-full:latest

USER root

# Get linting dependencies
## Hadolint - For dockerfile linting
COPY gitpod/scripts/hadolint.sh /usr/bin/hadolint-script
RUN true "" \
	&& chmod +x /usr/bin/hadolint-script \
	&& /usr/bin/hadolint-script \
	&& rm /usr/bin/hadolint-script