# Workspace Images

[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-908a85?logo=gitpod)](https://gitpod.io/#https://github.com/gitpod-io/workspace-images)
[![Build from Main](https://github.com/gitpod-io/workspace-images/actions/workflows/push-main.yml/badge.svg)](https://github.com/gitpod-io/workspace-images/actions/workflows/push-main.yml)

Ready-to-use Docker images for [gitpod.io](https://www.gitpod.io) workspaces. All images are available on Docker Hub under [gitpod/*](https://hub.docker.com/u/gitpod).


## 📢 Announcements

We're upgrading to support [dazzle v2](https://github.com/gitpod-io/dazzle) and build with Github Actions.

Some images may break briefly as part of the upgrade effort. If you have trouble using the `latest` tag, please try `legacy-dazzle-v1`. Think of it as an "escape hatch".

We'll initially release `gitpod/workspace-full`, and then others, updating this page as we go.

The old build process which used dazzle v1 and CircleCI is deprecated, and will not be used for future builds.

### 📷 Images we'll upgrade

1. gitpod/workspace-full ✅
1. gitpod/workspace-base ✅
1. gitpod/workspace-dotnet ✅
1. gitpod/workspace-full-vnc ✅
1. gitpod/workspace-mongodb ✅
1. gitpod/workspace-mysql ✅
1. gitpod/workspace-postgres ✅

### 🆕 Images

These are lightweight compared to `gitpod/workspace-full`.

Each contains a set of chunks: a common base, a language, and includes Docker and Tailscale.

1. gitpod/workspace-c ✅
1. gitpod/workspace-clojure ✅
1. gitpod/workspace-go ✅
1. gitpod/workspace-java-11 ✅
1. gitpod/workspace-java-17 ✅
1. gitpod/workspace-node ✅
1. gitpod/workspace-node-lts ✅
1. gitpod/workspace-python ✅
1. gitpod/workspace-ruby-2 ✅
1. gitpod/workspace-ruby-3 ✅
1. gitpod/workspace-rust ✅

### 🎬 No upgrade planned

These images are no longer being published, and not planned for Upgrade:

1. gitpod/workspace-images-dazzle
1. gitpod/workspace-dotnet-vnc
1. gitpod/workspace-dotnet-lts
1. gitpod/workspace-dotnet-lts-vnc
1. gitpod/workspace-flutter
1. gitpod/workspace-gecko
1. gitpod/workspace-wasm
1. gitpod/workspace-firefox
1. gitpod/workspace-full-dazzle
1. gitpod/workspace-mysql-8
1. gitpod/workspace-python-tk-vnc
1. gitpod/workspace-python-tk
1. gitpod/workspace-rethinkdb
1. gitpod/workspace-thin
1. gitpod/workspace-webassembly

## Contributing

You can follow the detailed guide on how to contribute [here](CONTRIBUTING.md).

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/gitpod-io/workspace-images)
