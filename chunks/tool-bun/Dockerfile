ARG base
FROM ${base}

ARG BUN_VERSION

ENV BUN_INSTALL="${HOME}/.bun"
ENV PATH="${BUN_INSTALL}/bin:${PATH}"

ENV BUN_VERSION=${BUN_VERSION}

# Install bun
RUN curl -fsSL https://bun.sh/install | bash -s "bun-v${BUN_VERSION}"

# Custom bug config for Gitpod
COPY --chown=gitpod:gitpod .bunfig.toml "$HOME"
