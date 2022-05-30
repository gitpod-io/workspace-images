FROM gitpod/workspace-full

# Add gcloud cli package source and install
RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
RUN sudo apt-get update && sudo apt-get install -y google-cloud-sdk

# Install kubectl
RUN sudo apt-get install -y kubectl
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

# Install helm
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Install SOPS
RUN wget https://github.com/mozilla/sops/releases/download/v3.7.1/sops_3.7.1_amd64.deb \
    && sudo dpkg -i sops_3.7.1_amd64.deb \
    && rm sops_3.7.1_amd64.deb

# Install yaml
RUN sudo curl -fSL "https://github.com/mikefarah/yq/releases/download/v4.18.1/yq_linux_amd64" -o "/usr/local/bin/yaml" && sudo chmod +x /usr/local/bin/yaml

# Install helm secrets
RUN helm plugin install https://github.com/jkroepke/helm-secrets --version v3.8.1

# Install additional packages
RUN sudo apt-get update && sudo apt-get install -y libnss3-tools

# Install PHP 8.1
# Start by killing apache2 since we don't need it and it causes an interactive CLI to pop up.
RUN sudo service apache2 stop; sudo apt-get purge apache2 -y; sudo apt-get autoremove -y; sudo rm -rf /etc/apache2 \
    && sudo add-apt-repository ppa:ondrej/php -y \
    && sudo apt-get update -y \
    && sudo apt-get install -y php8.1 php8.1-common php8.1-dom php8.1-curl php8.1-gd php8.1-zip php8.1-mysql

# Upgrade composer
RUN sudo apt-get remove -y composer \
    && wget -O composer-setup.php https://getcomposer.org/installer \
    && sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php

# Install google-chrome-stable
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
RUN sudo apt-get update && sudo apt-get install -y google-chrome-stable

# Install frontend tools
RUN yarn global add @angular/cli grunt

# Set environment variables in profile to prevent certain errors
RUN echo "export CLOUDSDK_PYTHON=/usr/bin/python3" >> /home/$USER/.bashrc
RUN echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/lib" >> /home/$USER/.bashrc
RUN echo "export PATH=\$PATH:\$(yarn global bin)" >> /home/$USER/.bashrc
RUN echo "export CHROME_BIN=/usr/bin/google-chrome-stable" >> /home/$USER/.bashrc
