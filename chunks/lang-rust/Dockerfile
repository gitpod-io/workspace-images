ARG base
FROM ${base}

ARG RUST_VERSION

USER gitpod

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=7
ENV RUST_VERSION=${RUST_VERSION}

ENV PATH=$HOME/.cargo/bin:$PATH

RUN curl -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path --default-toolchain ${RUST_VERSION} \
        -c rust-analyzer rust-src rustfmt clippy \
    && for cmp in rustup cargo; do rustup completions bash "$cmp" > "$HOME/.local/share/bash-completion/completions/$cmp"; done \
    && cargo install cargo-watch cargo-edit cargo-workspaces \
    && rm -rf "$HOME/.cargo/registry" # This registry cache is now useless as we change the CARGO_HOME path to `/workspace`

# Helpful for Gitpod prebuilds
RUN rustup set auto-self-update disable
ENV CARGO_HOME=/workspace/.cargo
ENV CARGO_INSTALL_ROOT=$HOME/.cargo
ENV RUSTUP_HOME=$HOME/.rustup
