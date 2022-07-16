ARG base
# hadolint ignore=DL3006
FROM ${base}

USER root

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1
# hadolint ignore=DL4006
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | gosu root apt-key add - \
    && curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | gosu root tee /etc/apt/sources.list.d/tailscale.list \
    && install-packages tailscale \
    && rm /etc/apt/sources.list.d/tailscale.list

## "apt-key add" adds a PGP to a joint file which does not make it through dazzle.
## If we didn't remove the source list entry above, subsequent apt-get operations would break.

USER gitpod
