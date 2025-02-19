ARG base
FROM ${base}

USER root

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

USER gitpod

# Install asdf to make it easier to manage elixir versions
#
# Why?
# 1. At the time of this writing, `apt-get install elixir` was installing
# a version that was not compatible with glibc in Ubuntu Jammy.
# 2. This makes it explicit as to what versions we're installing.
# 3. It'll give users the ability to easily make changes at runtime to experiment
RUN	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.1
RUN echo ". "$HOME/.asdf/asdf.sh"" >> /home/gitpod/.bashrc.d/100-asdf
RUN echo ". "$HOME/.asdf/completions/asdf.bash"" >> /home/gitpod/.bashrc.d/100-asdf
ENV PATH=/home/gitpod/.asdf/bin:/home/gitpod/.asdf/shims:$PATH

RUN asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git \
    && asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git \
    && asdf install erlang 25.2.2 \
    && asdf install elixir 1.13.4-otp-25 \
    && asdf global erlang 25.2.2 \
    && asdf global elixir 1.13.4-otp-25
