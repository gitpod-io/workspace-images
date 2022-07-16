ARG base
# hadolint ignore=DL3006
FROM ${base}

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

RUN gosu root install-packages ca-certificates

USER gitpod
