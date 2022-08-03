ARG base
FROM ${base}

ARG RUBY_VERSION

USER gitpod

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

RUN curl -fsSL https://rvm.io/mpapis.asc | gpg --import - \
    && curl -fsSL https://rvm.io/pkuczynski.asc | gpg --import - \
    && curl -fsSL https://get.rvm.io | bash -s stable

SHELL ["/usr/bin/bash", "-lc"]
RUN rvm requirements \
        && rvm install ${RUBY_VERSION} \
        && rvm use ${RUBY_VERSION} --default \
        && rvm rubygems current \
        && gem install bundler --no-document \
        && gem install solargraph --no-document
