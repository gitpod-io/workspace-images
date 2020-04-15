# Changelog

A curated, chronologically ordered list of notable changes in [Gitpod's default workspace images](https://hub.docker.com/u/gitpod).

## 2020-04-15

- @Kreyren rewrote the repository
  - New "Gitpod docker cores" - Gitpod users has now the option of using `gitpod/<core>` dockerimages that set the mandatory minimums for specified dockerimage
    - Support for Debian
    - Support for Exherbo (gnu and musl options)
    - Support for Gentoo
    - Support for Archlinux
    - WIP: Rewritten support for Ubuntu to make it more managable
    - Support for other Linux distributions on demand
    - Support for other kernels using Vagrant on hold
    - Gitpod layers now support multiple distributions allowing them to be built
  - Various code quality fixes
    - WIP: CircleCI frontend has been rewritten to comply with code quality standard
  - New features
    - WIP: End-users can now use `shell` property in their `gitpod.yml` files to use following shells:
      - Bash
      - Shell
      - Powershell (Using powershell for linux)
    - WIP: End-users can now set PS1 per repository
    - WIP: End-users can now use `package` property in `gitpod.yml` to install various packages without the need to use dockerfile

## 2020-04-15

- Upgrade from Ubuntu 19.04 → Ubuntu 20.04 LTS, because 19.04 reached end-of-life and all its apt packages got deleted https://github.com/gitpod-io/gitpod/issues/1398

## 2020-04-06

- Make noVNC (virtual desktop) automatically reconnect if the connection is dropped, and enable noVNC toolbar https://github.com/gitpod-io/workspace-images/pull/170

## 2020-03-30

- Upgrade Node.js from v10 → v12 LTS (to pin a specific version, see [this workaround](https://github.com/gitpod-io/workspace-images/pull/178#issuecomment-602465333))

---
Inspired by [keepachangelog.com](https://keepachangelog.com/).
