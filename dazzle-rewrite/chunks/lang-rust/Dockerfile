ARG base
FROM ${base}

USER gitpod
RUN cp /home/gitpod/.profile /home/gitpod/.profile_orig && \
    curl -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal --default-toolchain 1.56.1 \
    && .cargo/bin/rustup component add \
        rls \
        rust-analysis \
        rust-src \
        rustfmt \
    && .cargo/bin/rustup completions bash | sudo tee /etc/bash_completion.d/rustup.bash-completion > /dev/null \
    && .cargo/bin/rustup completions bash cargo | sudo tee /etc/bash_completion.d/rustup.cargo-bash-completion > /dev/null \
    && grep -v -F -x -f /home/gitpod/.profile_orig /home/gitpod/.profile > /home/gitpod/.bashrc.d/80-rust
ENV PATH=$PATH:$HOME/.cargo/bin
# TODO: setting CARGO_HOME to /workspace/.cargo avoids manual updates. Remove after full workspace backups are GA.
ENV CARGO_HOME=/workspace/.cargo
ENV PATH=$CARGO_HOME/bin:$PATH

RUN sudo mkdir -p $CARGO_HOME \
    && sudo chown -R gitpod:gitpod $CARGO_HOME

RUN bash -lc "cargo install cargo-watch cargo-edit cargo-tree cargo-workspaces"