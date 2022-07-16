ARG base
# hadolint ignore=DL3006
FROM ${base}

USER root

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=2

# hadolint ignore=DL4006
RUN curl -fsSL https://apt.llvm.org/llvm-snapshot.gpg.key | gosu root gpg --dearmor -o /usr/share/keyrings/llvm-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/llvm-archive-keyring.gpg] http://apt.llvm.org/focal/ llvm-toolchain-focal main" | gosu root tee /etc/apt/sources.list.d/llvm.list > /dev/null \
    && install-packages \
        clang \
        clangd \
        clang-format \
        clang-tidy \
        gdb \
        lld

USER gitpod
