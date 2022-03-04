ARG base
FROM ${base}

USER root

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

# chrome and basic render font
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/chrome-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/chrome-archive-keyring.gpg] https://dl.google.com/linux/chrome/deb/ \
    stable main" | tee /etc/apt/sources.list.d/google-chrome.list > /dev/null \
    && apt update \
    && install-packages google-chrome-stable

USER gitpod

# misc deps for electron and puppeteer to run
RUN sudo install-packages \
    libasound2-dev libgtk-3-dev libnss3-dev \
    fonts-noto fonts-noto-cjk

# For Qt WebEngine on docker
ENV QTWEBENGINE_DISABLE_SANDBOX 1
