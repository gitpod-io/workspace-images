ARG base
FROM ${base}

ARG JAVA_VERSION

USER gitpod

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

SHELL [ "/bin/bash", "-c" ]
RUN curl -fsSL "https://get.sdkman.io" | bash \
	&& source "$HOME/.sdkman/bin/sdkman-init.sh" \
	&& sed -i -e 's/sdkman_selfupdate_enable=true/sdkman_selfupdate_enable=false/g' \
	-e 's/sdkman_selfupdate_feature=true/sdkman_selfupdate_feature=false/g' "$HOME/.sdkman/etc/config" \
	&& sdk install java ${JAVA_VERSION} \
	&& sdk install java 17.0.3.fx-zulu \
	&& sdk default java ${JAVA_VERSION} \
	&& sdk install gradle \
	&& sdk install maven \
	&& sdk flush archives \
	&& sdk flush temp \
	&& mkdir -p "$HOME/.m2"

COPY --chown=gitpod:gitpod java.bash "$HOME/.bashrc.d/99-java"