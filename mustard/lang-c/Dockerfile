ARG base
FROM ${base}

USER root

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

RUN curl -fsSL https://apt.llvm.org/llvm-snapshot.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/llvm-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/llvm-archive-keyring.gpg] http://apt.llvm.org/jammy/ \
    llvm-toolchain-jammy-19 main" | sudo tee /etc/apt/sources.list.d/llvm.list > /dev/null \
    && apt update \
    && install-packages \
        clang-19 \
        clangd-19 \
        clang-format-19 \
        clang-tidy-19 \
        gdb \
        lld-19 \
        libclang-19-dev \
        clang-tools-19

RUN sudo update-alternatives --install /usr/bin/clang clang /usr/lib/llvm-19/bin/clang 100 \
    && sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/lib/llvm-19/bin/clang++ 100 \
    && sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-19 100 \
    && sudo update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-19 100 \
    && sudo update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-19 100 \
    && sudo update-alternatives --install /usr/bin/lld lld /usr/bin/lld-19 100

USER gitpod
