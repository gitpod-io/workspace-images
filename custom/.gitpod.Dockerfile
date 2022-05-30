# Hosted image is available at axonasif/gitpod-base-node-vnc:latest
# However, you could push to your own docker account too after building and use it on work repos :)
# The local dazzle built image will be localhost:5000/dazzle:base-node-vnc

ARG image
FROM ${image}

USER root
# Add gcloud cli package source and install additional packages
RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    \
    # Add PHP source
    && add-apt-repository ppa:ondrej/php -y \
    \
    # Install all packages together: kubectl, gcloud, php
    && install-packages kubectl google-cloud-sdk libnss3-tools php8.1 php8.1-common php8.1-dom php8.1-curl php8.1-gd php8.1-zip php8.1-mysql \
    \
    # SOPS
    && wget https://github.com/mozilla/sops/releases/download/v3.7.1/sops_3.7.1_amd64.deb \
    && dpkg -i sops_3.7.1_amd64.deb && rm sops_3.7.1_amd64.deb \
    \
    # YAML
    && curl -fSL "https://github.com/mikefarah/yq/releases/download/v4.18.1/yq_linux_amd64" -o "/usr/local/bin/yaml" \
    && chmod +x /usr/local/bin/yaml \
    \
    # Update composer
    && wget -O composer-setup.php https://getcomposer.org/installer \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php \
    \
    # Fix $HOME permissions (the composer installation turns a few things into `root` owner)
    && chown -hR gitpod:gitpod /home/gitpod

USER gitpod
# Install helm and heml-secrets
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash \
    && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash \
    && helm plugin install https://github.com/jkroepke/helm-secrets --version v3.8.1 \
    \
    # Install frontend tools
    && bash -lc 'yarn global add @angular/cli grunt' \
    \
    # Set environment variables in profile to prevent certain errors
    && printf '%s\n' "export CLOUDSDK_PYTHON=/usr/bin/python3" \
                    'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib' \
                    'export PATH=$PATH:$(yarn global bin)' \
                    'export CHROME_BIN=$(command -v google-chrome)' >> $HOME/.bashrc
