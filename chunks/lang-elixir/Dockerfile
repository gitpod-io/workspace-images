ARG base
FROM ${base}

USER root

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

RUN cd /tmp \
	&& wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb \
	&& dpkg -i erlang-solutions_2.0_all.deb \
	&& install-packages elixir

USER gitpod
