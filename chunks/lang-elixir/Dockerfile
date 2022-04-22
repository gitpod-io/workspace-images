ARG base
FROM ${base}

USER root

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

# jammy provides Erlang/OTP 24: https://packages.ubuntu.com/jammy/erlang
RUN install-packages elixir

USER gitpod
