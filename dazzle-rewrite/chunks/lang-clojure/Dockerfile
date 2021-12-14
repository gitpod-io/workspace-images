ARG base
FROM ${base}

USER root
ENV TRIGGER_REBUILD=2
RUN install-packages rlwrap
RUN curl https://download.clojure.org/install/linux-install-1.10.3.1029.sh -o /tmp/linux-install-1.10.3.1029.sh \
    && chmod +x /tmp/linux-install-1.10.3.1029.sh \
    && /tmp/linux-install-1.10.3.1029.sh \
    && rm /tmp/linux-install-1.10.3.1029.sh
