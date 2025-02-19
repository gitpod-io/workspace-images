ARG base
FROM ${base}

USER root

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=3

RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.gpg | sudo apt-key add - \
    && curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.list | sudo tee /etc/apt/sources.list.d/tailscale.list \
    && apt-get update \
    && apt-get install -y tailscale \
    && rm /etc/apt/sources.list.d/tailscale.list \
    && update-alternatives --set ip6tables /usr/sbin/ip6tables-nft

## "apt-key add" adds a PGP to a joint file which does not make it through dazzle.
## If we didn't remove the source list entry above, subsequent apt-get operations would break.

USER gitpod
