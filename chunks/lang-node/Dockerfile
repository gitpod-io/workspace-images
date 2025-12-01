ARG base
FROM ${base}

ARG NODE_VERSION

USER gitpod

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1
ENV NODE_VERSION=${NODE_VERSION}

ENV PNPM_HOME=/home/gitpod/.pnpm
ENV PATH=/home/gitpod/.nvm/versions/node/v${NODE_VERSION}/bin:/home/gitpod/.yarn/bin:${PNPM_HOME}:$PATH

RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | PROFILE=/dev/null bash \
    && bash -c ". .nvm/nvm.sh \
        && nvm install v${NODE_VERSION} \
        && nvm alias default v${NODE_VERSION} \
        && npm install -g typescript yarn pnpm node-gyp" \
    && echo ". ~/.nvm/nvm-lazy.sh"  >> /home/gitpod/.bashrc.d/50-node
# above, we are adding the lazy nvm init to .bashrc, because one is executed on interactive shells, the other for non-interactive shells (e.g. plugin-host)
COPY --chown=gitpod:gitpod nvm-lazy.sh /home/gitpod/.nvm/nvm-lazy.sh

RUN sudo rm -f /usr/bin/npx /usr/local/bin/npx && \
    echo '#!/bin/sh' | sudo tee /usr/local/bin/npx && \
    echo 'echo "npx is disabled for security reasons. Use explicit package installation instead." >&2' | sudo tee -a /usr/local/bin/npx && \
    echo 'exit 1' | sudo tee -a /usr/local/bin/npx && \
    sudo chmod +x /usr/local/bin/npx

RUN npm config set ignore-scripts true --location=user && \
    echo 'ignore-scripts true' >> /home/gitpod/.yarnrc
