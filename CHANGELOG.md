# Changelog

A curated, chronologically ordered list of notable changes in [Gitpod's default workspace images](https://hub.docker.com/u/gitpod).

## 2020-04-29

- Upgrade RVM's Ruby from `2.5` → `2.5.8` and `2.6` → `2.7.1` [gitpod-io/workspace-images#213](https://github.com/gitpod-io/workspace-images/pull/213)
- Best practice: Don't stay as `USER root` in `gitpod/workspace-full-vnc` [gitpod-io/workspace-images#215](https://github.com/gitpod-io/workspace-images/pull/215)
- Add bash auto-completion for `cargo` [gitpod-io/workspace-images#216](https://github.com/gitpod-io/workspace-images/pull/216)

## 2020-04-21

- Upgrade Pyenv's Python from `3.7.7` → `3.8.2` [gitpod-io/workspace-images#212](https://github.com/gitpod-io/workspace-images/pull/212)
- Drop support of .NET `2.2`, because it reached [end-of-life](https://dotnet.microsoft.com/platform/support/policy/dotnet-core) on 2019-12-23

## 2020-04-17

- Fix PostgreSQL image and pin to PostgreSQL version `12` [gitpod-io/workspace-images#209](https://github.com/gitpod-io/workspace-images/pull/209)
- Upgrade Rust `1.41.1` → `1.42.0` [gitpod-io/workspace-images#207](https://github.com/gitpod-io/workspace-images/pull/207)
- Fix MySQL image by updating mysql.cnf for MySQL `8`, fixes [gitpod-io/gitpod#1399](https://github.com/gitpod-io/gitpod/issues/1399)

## 2020-04-15

- Upgrade from Ubuntu `19.04` → Ubuntu `20.04 LTS`, because `19.04` reached end-of-life and all its apt packages got deleted [gitpod-io/gitpod#1398](https://github.com/gitpod-io/gitpod/issues/1398)
- Upgrade Java `11.0.5.fx-zulu` → `11.0.6.fx-zulu`

## 2020-04-06

- Make noVNC (virtual desktop) automatically reconnect if the connection is dropped, and enable noVNC toolbar [gitpod-io/workspace-images#170](https://github.com/gitpod-io/workspace-images/pull/170)

## 2020-03-30

- Upgrade Node.js from `v10` → `v12 LTS` (to pin a specific version, see [this workaround](https://github.com/gitpod-io/workspace-images/pull/178#issuecomment-602465333))

---
Inspired by [keepachangelog.com](https://keepachangelog.com/).
