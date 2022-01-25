# Workspace Images

[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-908a85?logo=gitpod)](https://gitpod.io/#https://github.com/gitpod-io/workspace-images)
![Build](https://github.com/github/docs/actions/workflows/push-main.yml/badge.svg)


Ready-to-use Docker images for [gitpod.io](https://www.gitpod.io) workspaces. All images are available on Docker Hub under [gitpod/*](https://hub.docker.com/u/gitpod).

## 📢 NOTICES

We have deprecated the build process involving use of dazzle v1 and we are migrating to use of [dazzle v2](https://github.com/gitpod-io/dazzle).
No new images will be published using old process.

It is expected that with this migration we might break images briefly, so, as an escape hatch we have retagged the current `latest` to `legacy-dazzle-v1`.

## Legacy Images (dazzle v1)

If you are impacted by the migration and would like to continue using the last working images while the community fixes the issues you can use the tagged images listed in the following section.

### Tagged

1. gitpod/workspace-full
1. gitpod/workspace-dotnet-lts-vnc
1. gitpod/workspace-dotnet-vnc
1. gitpod/workspace-images-dazzle
1. gitpod/workspace-full-vnc
1. gitpod/workspace-wasm
1. gitpod/workspace-flutter
1. gitpod/workspace-dotnet
1. gitpod/workspace-mysql
1. gitpod/workspace-dotnet-lts
1. gitpod/workspace-postgres
1. gitpod/workspace-mongodb
1. gitpod/workspace-base
1. gitpod/workspace-gecko


### Not tagged

The following images are not tag because of issues:

1. gitpod/workspace-images-dazzle --- This is not being used by users

The following images are not tagged because they are not being published now:

1. gitpod/workspace-python-tk-vnc
1. gitpod/workspace-python-tk
1. gitpod/workspace-thin
1. gitpod/workspace-webassembly
1. gitpod/workspace-firefox
1. gitpod/workspace-full-dazzle
1. gitpod/workspace-mysql-8
1. gitpod/workspace-rethinkdb


PRs are very welcome! ❤️

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/gitpod-io/workspace-images)
