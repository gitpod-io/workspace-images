# Workspace Images

[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-908a85?logo=gitpod)](https://gitpod.io/#https://github.com/gitpod-io/workspace-images)
[![Build from Main](https://github.com/gitpod-io/workspace-images/actions/workflows/push-main.yml/badge.svg)](https://github.com/gitpod-io/workspace-images/actions/workflows/push-main.yml)

Ready-to-use Docker images for [gitpod.io](https://www.gitpod.io) workspaces.
All images are available on [Gitpod's Dockerhub page](https://hub.docker.com/u/gitpod).

For an example of how to use these images, please take a look at the [documentation](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-public-docker-image).

## 📢 Announcements

We upgraded to support [dazzle v2](https://github.com/gitpod-io/dazzle) and build with GitHub Actions.

## Summary

- **Operating System**: Ubuntu 22.04.2 LTS
- **OS Type**: Linux
- **Architecture**: x86_64

## Images

By default, Gitpod uses a standard Docker Image called
[`workspace-full`](https://github.com/gitpod-io/workspace-images/blob/HEAD/dazzle.yaml#L23) as the foundation for workspaces.

Workspaces started based on this default image come pre-installed with
Docker, Nix, Go, Java, Node.js, C/C++, Python, Ruby, Rust & PHP as well as tools such as Homebrew, Tailscale, Nginx & several more.

If this image does not include the tools you need for your repository, we recommend you start with
[`workspace-base`](https://github.com/gitpod-io/workspace-images/blob/HEAD/dazzle.yaml#L3) and customize it according to your needs.
You can refer to this [document to setup a custom docker image](https://www.gitpod.io/docs/configure/workspaces/workspace-image).

### 📷 Images we'll maintain

- [`gitpod/workspace-full`](https://hub.docker.com/r/gitpod/workspace-full) ✅
- [`gitpod/workspace-base`](https://hub.docker.com/r/gitpod/workspace-base) ✅
- [`gitpod/workspace-dotnet`](https://hub.docker.com/r/gitpod/workspace-dotnet) ✅
- [`gitpod/workspace-full-vnc`](https://hub.docker.com/r/gitpod/workspace-full-vnc) ✅
- [`gitpod/workspace-mongodb`](https://hub.docker.com/r/gitpod/workspace-mongodb) ✅
- [`gitpod/workspace-mysql`](https://hub.docker.com/r/gitpod/workspace-mysql) ✅
- [`gitpod/workspace-postgres`](https://hub.docker.com/r/gitpod/workspace-postgres) ✅

### 🆕 Specific Images

These are lightweight compared to `gitpod/workspace-full`.

Each contains a set of chunks: a common base, and a language, and includes Docker and Tailscale.

- [`gitpod/workspace-c`](https://hub.docker.com/r/gitpod/workspace-c) ✅
- [`gitpod/workspace-clojure`](https://hub.docker.com/r/gitpod/workspace-clojure) ✅
- [`gitpod/workspace-go`](https://hub.docker.com/r/gitpod/workspace-go) ✅
- [`gitpod/workspace-java-11`](https://hub.docker.com/r/gitpod/workspace-java-11) ✅
- [`gitpod/workspace-java-17`](https://hub.docker.com/r/gitpod/workspace-java-17) ✅
- [`gitpod/workspace-node`](https://hub.docker.com/r/gitpod/workspace-node) ✅
- [`gitpod/workspace-node-lts`](https://hub.docker.com/r/gitpod/workspace-node-lts) ✅
- [`gitpod/workspace-python`](https://hub.docker.com/r/gitpod/workspace-python) ✅
- [`gitpod/workspace-ruby-3`](https://hub.docker.com/r/gitpod/workspace-ruby-3) ✅
- [`gitpod/workspace-ruby-3.0`](https://hub.docker.com/r/gitpod/workspace-ruby-3.0) ✅
- [`gitpod/workspace-ruby-3.1`](https://hub.docker.com/r/gitpod/workspace-ruby-3.1) ✅
- [`gitpod/workspace-rust`](https://hub.docker.com/r/gitpod/workspace-rust) ✅
- [`gitpod/workspace-elixir`](https://hub.docker.com/r/gitpod/workspace-elixir) ✅

### 🎬 No upgrade planned

⚠️ These images are no longer being published, and are not planned for Upgrade:

- gitpod/workspace-images-dazzle
- gitpod/workspace-dotnet-vnc
- gitpod/workspace-dotnet-lts
- gitpod/workspace-dotnet-lts-vnc
- gitpod/workspace-flutter
- gitpod/workspace-gecko
- gitpod/workspace-wasm
- gitpod/workspace-firefox
- gitpod/workspace-full-dazzle
- gitpod/workspace-mysql-8
- gitpod/workspace-python-tk-vnc
- gitpod/workspace-python-tk
- gitpod/workspace-rethinkdb
- gitpod/workspace-thin
- gitpod/workspace-webassembly

### 📢 Deprecated images

These images are no longer being published:

- gitpod/workspace-python-3.9 or older (please use [`gitpod/workspace-python-3.12`](https://hub.docker.com/r/gitpod/workspace-python-3.12) instead)
- gitpod/workspace-postgresql (please use [`gitpod/workspace-postgres`](https://hub.docker.com/r/gitpod/workspace-postgres) instead)
- gitpod/workspace-ruby-2 (please use [`gitpod/workspace-ruby-3.2`](https://hub.docker.com/r/gitpod/workspace-ruby-3.2) instead)

## Contributing

You can follow the detailed guide on how to contribute [here](CONTRIBUTING.md).

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/gitpod-io/workspace-images)

## Where to follow new updates

- **Announcements**: Significant changes and breaking updates are announced through the [CHANGELOG.md](/CHANGELOG.md) file with details.
- **Recently Merged Changes**: For checking new features or updates staged for next deployment that don't warrant everyone's attention, browse through the [merged pull requests](https://github.com/gitpod-io/workspace-images/pulls?q=is%3Apr+is%3Amerged).
- **Image Updates**: Every Monday, [a GitHub action](https://github.com/gitpod-io/workspace-images/actions/workflows/dockerhub-release.yml?query=is%3Asuccess) automatically builds and updates the images based on the `main` branch. Once built, these images are made available on [Gitpod's Docker Hub](https://hub.docker.com/u/gitpod).
