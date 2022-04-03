ARG base
FROM ${base}

USER gitpod

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

RUN curl -o /tmp/nvim.deb -fsSL https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.deb \
    && sudo apt install /tmp/nvim.deb \
    && rm -f /tmp/nvim.deb
