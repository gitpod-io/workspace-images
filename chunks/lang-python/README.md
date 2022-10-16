# workspace-python

## How to use for a Gitpod workspace

Put the following line in your `.gitpod.yml`:

If you do not have a `.gitpod.yml`, run `gp init` on your terminal to create one.

```yaml
image: gitpod/workspace-python
```

Lastly, [see it in action!](https://www.gitpod.io/docs/introduction/learn-gitpod/gitpod-yaml#see-it-in-action)

### Extra docker image variants

We provide multiple variants of the `gitpod/workspace-python` docker image as per [chunk.yaml](./chunk.yaml). Each containing a different version of Python:

- `gitpod/workspace-python-3.7` (This is python 3.7.13)
- `gitpod/workspace-python` (This is python 3.8.13)
- `gitpod/workspace-python-3.9` (This is python 3.9.13)
- `gitpod/workspace-python-3.10` (This is python 3.10.6)

You could use these on your `.gitpod.yml` as well.

## Details

This is mainly optimized for [Python](https://www.python.org/), and is based on [workspace-base](../../base/)

The following are installed for you, you can extend using a [custom-docker-image](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-custom-dockerfile) if you wish.

- Standard system-wide python interpreter(s) is available under `/usr/bin` (e.g. `python3`, `python2.7`), as well as `/usr/bin/pip3`.
- For a user-land installation, we use `pyenv`
    - With `pyenv` a complete Python runtime is installed, the version [depends on the image you're using](#extra-docker-image-variants).
- Some extra packages are installed on the user-land installation with `pip`:
    - setuptools, wheel, virtualenv,pipenv
    - pylint, rope, flake8, mypy, autopep8
    - pep8, pylama, pydocstyle
    - bandit, notebook, twine
- Poetry is also installed and configured

### To be aware of

Several _hacks_ were implemented to persist `pip` packages or `pyenv install <ver>` that were installed from [custom-docker-image](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-custom-dockerfile) build environment, [prebuilds](https://www.gitpod.io/docs/configure/projects/prebuilds) environment and in between workspace reboots. These hacks are utilizing [`pyenv` hooks](https://github.com/pyenv/pyenv/wiki/Authoring-plugins#pyenv-hooks).

If you install python versions using `pyenv install <ver>` or install packages with `pip` inside a [custom-docker-image](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-custom-dockerfile) build environment, they will be installed inside `$HOME/.pyenv/version/<version-code>/` as usual.

However, inside a running workspace or from [prebuilds](https://www.gitpod.io/docs/configure/projects/prebuilds) environment, `pyenv install <ver>` will use `/workspace/.pyenv_mirror/fakeroot/versions/<version-code>`. And all `pip` command will use `/workspace/.pyenv_mirror/user/<verion-code>` as the site-packages index.

If you're interested to understand how this works, check out the following:

- [pyenv.d](./pyenv.d/)
- [python_hook.bash](./python_hook.bash)
- [userbase.bash](./userbase.bash)

We also set some defaults for the VSCode Pylance extension:

```json
{
    "python.defaultInterpreterPath": "/home/gitpod/.pyenv/shims/python",
    "python.terminal.activateEnvironment": false
}
```
