ARG base
# hadolint ignore=DL3006
FROM ${base}

USER root

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1
# hadolint ignore=DL4006
RUN curl -fsSL https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | gosu root gpg --dearmor -o /usr/share/keyrings/erlang_solutions.gpg.key \
    && echo "deb [signed-by=/usr/share/keyrings/erlang_solutions.gpg.key] https://packages.erlang-solutions.com/ubuntu focal contrib" | gosu root tee /etc/apt/sources.list.d/erlang.list > /dev/null \
    && install-packages elixir

USER gitpod
