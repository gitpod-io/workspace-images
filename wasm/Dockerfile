FROM gitpod/workspace-full

RUN bash -cl "cargo install wasm-pack cargo-wasm cargo-generate \
    && curl -fsSL https://wasmtime.dev/install.sh  | bash; \
       rustup target add wasm32-wasi"

RUN mkdir /tmp/wasm-sdk \
    && cd /tmp/wasm-sdk \
    && wget "https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-12/wasi-sdk_12.0_amd64.deb" \
    && sudo dpkg -i wasi-sdk_12.0_amd64.deb \
    && rm -rf /tmp/wasi-sdk

RUN git clone --depth 1 "https://github.com/emscripten-core/emsdk.git" $HOME/.emsdk \
    && cd $HOME/.emsdk \
    && ./emsdk install latest \
    && ./emsdk activate latest \
    && printf "\nsource $HOME/.emsdk/emsdk_env.sh\nclear\n" >> ~/.bashrc

RUN brew install binaryen wabt && brew install --build-from-source wasm-pack && rustup target add wasm32-unknown-unknown
