ARG base
# hadolint ignore=DL3006
FROM ${base}

ARG PYTHON_VERSION

USER gitpod
# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

ENV PATH="$HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH"
ENV PIPENV_VENV_IN_PROJECT=true
ENV PYENV_ROOT="$HOME/.pyenv"
# hadolint ignore=DL4006,DL3013
RUN gosu root install-packages \
        # Install python compiling dependencies for pyenv
        python3-pip make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
    # Install PYENV
    && curl -fsSL https://pyenv.run | bash \
    && pyenv update \
    && pyenv install ${PYTHON_VERSION} \
    && pyenv global ${PYTHON_VERSION} \
    # Install additional python packages
    && python3 -m pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --upgrade \
        setuptools wheel virtualenv pipenv pylint rope flake8 \
        mypy autopep8 pep8 pylama pydocstyle bandit notebook \
        twine \
    && gosu root rm -rf /tmp/*

COPY --chown=gitpod:gitpod pyenv.d $HOME/.gp_pyenv.d
COPY --chown=gitpod:gitpod python_bash_hook $HOME/.bashrc.d/60-python
COPY --chown=gitpod:gitpod avoid_userbase_hook.bash $HOME/.pyenv/pyenv.d/exec
