ARG base
FROM ${base}

USER root

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

RUN curl -fsSL https://apt.llvm.org/llvm-snapshot.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/llvm-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/llvm-archive-keyring.gpg] http://apt.llvm.org/jammy/ \
    llvm-toolchain-jammy-17 main" | sudo tee /etc/apt/sources.list.d/llvm.list > /dev/null \
    && apt update \
    && install-packages \
        clang-17 \
        clangd-17 \
        clang-format-17 \
        clang-tidy-17 \
        gdb \
        lld-17

RUN sudo update-alternatives --install /usr/bin/clang clang /usr/lib/llvm-17/bin/clang 100 \
    && sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/lib/llvm-17/bin/clang++ 100 \
    && sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-17 100 \
    && sudo update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-17 100 \
    && sudo update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-17 100 \
    && sudo update-alternatives --install /usr/bin/lld lld /usr/bin/lld-17 100

USER gitpod
