ARG base
FROM ${base}

USER gitpod

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

ENV PATH=$HOME/.cargo/bin:$PATH

RUN curl -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal --no-modify-path --default-toolchain stable \
        -c rls rust-analysis rust-src rustfmt clippy \
    && rustup completions bash | sudo tee /etc/bash_completion.d/rustup.bash-completion > /dev/null \
    && rustup completions bash cargo | sudo tee /etc/bash_completion.d/rustup.cargo-bash-completion > /dev/null \
    && printf '%s\n'    'export CARGO_HOME=/workspace/.cargo' \
                        'mkdir -m 0755 -p "$CARGO_HOME" 2>/dev/null' \
                        'export PATH=$CARGO_HOME/bin:$PATH' > $HOME/.bashrc.d/80-rust \
    && _rustup_path="$(which rustup)" && mv "$_rustup_path" "${_rustup_path}.main" \
    && cargo install cargo-watch cargo-edit cargo-workspaces \
    && rm -r "${_rustup_path%/*/*}/registry" # This registry cache is now useless as we change the CARGO_HOME path to `/workspace`

COPY --chown=gitpod:gitpod rustup $HOME/.cargo/bin
