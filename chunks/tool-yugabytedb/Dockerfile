ARG base
FROM ${base}

# Added for dazzle as it does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1
ARG YB_VERSION
ARG YB_BUILD
ARG YB_BIN_PATH=/usr/local/yugabyte
ARG ROLE=gitpod
ARG PYTHON_VERSION

USER $ROLE
# create bin and data path
RUN sudo mkdir -p $YB_BIN_PATH \
  && sudo mkdir -p /var/ybdp
# set permission
RUN sudo chown -R $ROLE:$ROLE /var/ybdp \
  && sudo chown -R $ROLE:$ROLE /usr/local/yugabyte

# fetch the binary
RUN curl -sSLo ./yugabyte.tar.gz https://downloads.yugabyte.com/releases/${YB_VERSION}/yugabyte-${YB_VERSION}-b${YB_BUILD}-linux-x86_64.tar.gz \
  && tar -xvf yugabyte.tar.gz -C $YB_BIN_PATH --strip-components=1 \
  && chmod +x $YB_BIN_PATH/bin/* \
  && rm ./yugabyte.tar.gz

# python is a required dependency of ycqlsh
# but it doesn't support Python 3.10+ due to https://github.com/yugabyte/cqlsh/issues/11, install 3.9 for now
# when building yugabyte combos, if our base is full, related python chunk tests fail
# so, use base as the combo ref, add chunks, but ignore Python chunk and install manually
ENV PATH="$HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH"
ENV PYENV_ROOT="$HOME/.pyenv"
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv \
  # v2.4.10
  && git -C ~/.pyenv checkout 9ecd803bffaffb949fbdd8c70cb086227f6a3202 \
  && pyenv install ${PYTHON_VERSION} \
  && pyenv global ${PYTHON_VERSION}

# configure the interpreter
RUN ["/usr/local/yugabyte/bin/post_install.sh"]

# set the execution path and other env variables
ENV PATH="$YB_BIN_PATH/bin/:$PATH"
ENV HOST=127.0.0.1
ENV STORE=/var/ybdp
ENV YSQL_PORT=5433
ENV YCQL_PORT=9042
ENV WEB_PORT=7000
ENV TSERVER_WEB_PORT=9000
ENV YSQL_API_PORT=13000
ENV YCQL_API_PORT=12000
ENV YUGABYTED_UI=15433

# re-initialization is automatically handled
RUN echo "\n# yugabytedb start command" >> /home/gitpod/.bashrc.d/100-yugabyedb-launch
RUN echo "[[ -f \${GITPOD_REPO_ROOT}/.nopreload ]] || yugabyted start --base_dir=$STORE --listen=$HOST > /dev/null" >> /home/gitpod/.bashrc.d/100-yugabyedb-launch

RUN chmod +x /home/gitpod/.bashrc.d/100-yugabyedb-launch

EXPOSE ${YSQL_PORT} ${YCQL_PORT} ${WEB_PORT} ${TSERVER_WEB_PORT} ${YSQL_API_PORT} ${YCQL_API_PORT} ${YUGABYTED_UI}
