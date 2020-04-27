# Changelog

A curated, chronologically ordered list of notable changes in [Gitpod's default workspace images](https://hub.docker.com/u/gitpod).

## 2020-04-21

- Upgrade Pyenv's Python from 3.7.7 → 3.8.2 https://github.com/gitpod-io/workspace-images/pull/212
- Drop support of .NET 2.2, because it reached End-Of-Life on 2019-12-23 https://dotnet.microsoft.com/platform/support/policy/dotnet-core

## 2020-04-17

- Fix PostgreSQL image and pin to PostgreSQL version 12 https://github.com/gitpod-io/workspace-images/pull/209
- Upgrade Rust 1.41.1 → 1.42.0 https://github.com/gitpod-io/workspace-images/pull/207
- Fix MySQL image by updating mysql.cnf for MySQL 8, fixes https://github.com/gitpod-io/gitpod/issues/1399

## 2020-04-15

- Upgrade from Ubuntu 19.04 → Ubuntu 20.04 LTS, because 19.04 reached end-of-life and all its apt packages got deleted https://github.com/gitpod-io/gitpod/issues/1398
- Upgrade Java 11.0.5.fx-zulu → 11.0.6.fx-zulu

## 2020-04-06

- Make noVNC (virtual desktop) automatically reconnect if the connection is dropped, and enable noVNC toolbar https://github.com/gitpod-io/workspace-images/pull/170

## 2020-03-30

- Upgrade Node.js from v10 → v12 LTS (to pin a specific version, see [this workaround](https://github.com/gitpod-io/workspace-images/pull/178#issuecomment-602465333))

---
Inspired by [keepachangelog.com](https://keepachangelog.com/).
