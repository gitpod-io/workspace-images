ARG base
FROM ${base}

USER gitpod

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

ENV PATH=$HOME/.cargo/bin:$PATH
RUN cp $HOME/.profile $HOME/.profile_orig \
    && curl -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal --default-toolchain 1.58.1 \
    && rustup component add \
        rls \
        rust-analysis \
        rust-src \
        rustfmt \
        clippy \
    && rustup completions bash | sudo tee /etc/bash_completion.d/rustup.bash-completion > /dev/null \
    && rustup completions bash cargo | sudo tee /etc/bash_completion.d/rustup.cargo-bash-completion > /dev/null \
    && printf '%s\n' "$(grep -v -F -x -f $HOME/.profile_orig $HOME/.profile)" \
                        'mkdir -m 0755 -p "${CARGO_HOME:-/workspace/.cargo}" 2>/dev/null' > $HOME/.bashrc.d/80-rust \
    && _rustup_path="$(command -v rustup)" && mv "$_rustup_path" "${_rustup_path}.main" \
    && printf '%s\n' '#!/usr/bin/bash -eu' \
                        'exec env -u CARGO_HOME "$(command -v rustup.main)" "$@"' > "$_rustup_path" \
    && chmod 0755 "$_rustup_path"

RUN cargo install cargo-watch cargo-edit cargo-workspaces
ENV CARGO_HOME=/workspace/.cargo
ENV PATH=$CARGO_HOME/bin:$PATH

RUN sudo mkdir -p $CARGO_HOME \
    && sudo chown -R gitpod:gitpod $CARGO_HOME

RUN bash -lc "cargo install cargo-watch cargo-edit cargo-tree cargo-workspaces"
