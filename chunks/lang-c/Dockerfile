ARG base
FROM ${base}

USER root

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

RUN curl -fsSL https://apt.llvm.org/llvm-snapshot.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/llvm-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/llvm-archive-keyring.gpg] http://apt.llvm.org/focal/ \
    llvm-toolchain-focal main" | sudo tee /etc/apt/sources.list.d/llvm.list > /dev/null \
    && apt update \
    && install-packages \
        clang \
        clangd \
        clang-format \
        clang-tidy \
        gdb \
        lld

USER gitpod
