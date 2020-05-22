FROM gitpod/workspace-full:latest

# Get linding dependencies
## Hadolint - For dockerfile linting
RUN \
	&& apt-get update \
	&& apt-get install -y hadolint