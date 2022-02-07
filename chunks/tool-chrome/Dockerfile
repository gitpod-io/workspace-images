ARG base
FROM ${base}

USER gitpod

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

# chrome and basic render font
RUN apt-get update \
  && apt-get install -y apt-transport-https \
  && curl -sSL https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add - \
  && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update && apt-get install -y google-chrome-stable --no-install-recommends \
  && apt-get install -y fonts-noto fonts-noto-cjk 

# misc deps for electron and puppeteer to run
RUN sudo apt-get update \
 && sudo apt-get install -y \
  libasound2-dev \
  libgtk-3-dev \
  libnss3-dev

# For Qt WebEngine on docker
ENV QTWEBENGINE_DISABLE_SANDBOX 1
