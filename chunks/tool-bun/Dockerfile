ARG base
FROM ${base}

ENV BUN_INSTALL="${HOME}/.bun"
ENV PATH="${BUN_INSTALL}:${PATH}"

# Install bun
RUN curl -fsSL https://bun.sh/install | bash

# Custom bug config for Gitpod
COPY --chown=gitpod:gitpod .bunfig.toml "$HOME"
