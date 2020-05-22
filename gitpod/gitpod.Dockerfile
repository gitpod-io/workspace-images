FROM gitpod/workspace-full:latest

# Get linding dependencies
## Hadolint - For dockerfile linting
COPY gitpod/scripts/hadolint.sh /usr/bin/hadolint-script
RUN true "" \
	&& chmod +x /usr/bin/hadolint-script \
	&& /usr/bin/hadolint-script \
	&& rm /usr/bin/hadolint-script