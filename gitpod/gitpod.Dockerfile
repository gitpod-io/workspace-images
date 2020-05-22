FROM gitpod/workspace-full:latest

# Get linting dependencies
## Hadolint - For dockerfile linting
COPY gitpod/scripts/hadolint.sh /usr/bin/hadolint-script
RUN true "" \
	&& sudo chmod +x /usr/bin/hadolint-script \
	&& /usr/bin/hadolint-script \
	&& sudo rm /usr/bin/hadolint-script