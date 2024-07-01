ARG base
FROM ${base}

USER root

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

RUN curl -fsSL https://apt.llvm.org/llvm-snapshot.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/llvm-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/llvm-archive-keyring.gpg] http://apt.llvm.org/jammy/ \
    llvm-toolchain-jammy-18 main" | sudo tee /etc/apt/sources.list.d/llvm.list > /dev/null \
    && apt update \
    && install-packages \
        clang-18 \
        clangd-18 \
        clang-format-18 \
        clang-tidy-18 \
        gdb \
        lld-18 \
        libclang-18-dev \
        clang-tools-18

RUN sudo update-alternatives --install /usr/bin/clang clang /usr/lib/llvm-18/bin/clang 100 \
    && sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/lib/llvm-18/bin/clang++ 100 \
    && sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-18 100 \
    && sudo update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-18 100 \
    && sudo update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-18 100 \
    && sudo update-alternatives --install /usr/bin/lld lld /usr/bin/lld-18 100

USER gitpod
