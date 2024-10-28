ARG base
FROM ${base}

ARG JAVA_VERSION

USER gitpod

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

RUN curl -fsSL "https://get.sdkman.io" | bash \
    && bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh \
    && sed -i 's/sdkman_selfupdate_enable=true/sdkman_selfupdate_enable=false/g' /home/gitpod/.sdkman/etc/config \
    && sed -i 's/sdkman_selfupdate_feature=true/sdkman_selfupdate_feature=false/g' /home/gitpod/.sdkman/etc/config \
    && sdk install java ${JAVA_VERSION} \
    && sdk install java 17.0.13.fx-zulu \
    && sdk default java ${JAVA_VERSION} \
    && sdk install gradle \
    # 4.x requires Java 17+ https://maven.apache.org/docs/history.html
    && sdk install maven 3.9.9 \
    && sdk flush archives \
    && sdk flush temp \
    && mkdir /home/gitpod/.m2 \
    && printf '<settings>\n  <localRepository>/workspace/m2-repository/</localRepository>\n</settings>\n' > /home/gitpod/.m2/settings.xml \
    && echo 'export SDKMAN_DIR=\"/home/gitpod/.sdkman\"' >> /home/gitpod/.bashrc.d/99-java \
    && echo '[[ -s \"/home/gitpod/.sdkman/bin/sdkman-init.sh\" ]] && source \"/home/gitpod/.sdkman/bin/sdkman-init.sh\"' >> /home/gitpod/.bashrc.d/99-java"
# above, we are adding the sdkman init to .bashrc (executing sdkman-init.sh does that), because one is executed on interactive shells, the other for non-interactive shells (e.g. plugin-host)
ENV GRADLE_USER_HOME=/workspace/.gradle/
