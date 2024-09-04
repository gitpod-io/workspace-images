ARG base
FROM ${base}

ARG RUBY_VERSION

USER gitpod

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=2

RUN curl -fsSL https://rvm.io/mpapis.asc | gpg --import - \
    && curl -fsSL https://rvm.io/pkuczynski.asc | gpg --import - \
    && curl -fsSL https://get.rvm.io | bash -s stable

ADD ./install.sh /tmp
RUN /tmp/install.sh $RUBY_VERSION




RUN echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*' >> /home/gitpod/.bashrc.d/70-ruby
RUN echo "rvm_gems_path=/workspace/.rvm" > ~/.rvmrc

ENV GEM_HOME=/workspace/.rvm
ENV GEM_PATH=$GEM_HOME:$GEM_PATH
ENV PATH=/home/gitpod/.rvm/bin:$PATH
