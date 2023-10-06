# Changelog

A curated, chronologically ordered list of notable changes in [Gitpod's default workspace images](https://hub.docker.com/u/gitpod).

## 2023-10-06

- Deprecate `gitpod/workspace-python-3.10`
- Introduce `gitpod/workspace-python-3.12`
- Bump default Python version in `workspace:full` to `3.12.0`

## 2023-10-02

- For `workspace-node`, deprecate Node 19 in favor of Node 20

## 2023-09-18

- Bump Rust to `1.72.0`

## 2023-09-15

- Bump the default Go version in all images to `1.21`
- Bump Go 1.21 to `1.21.1`

## 2023-07-11

- Bump Go 1.20 to `1.20.6` and Go 1.19 `1.19.11`

## 2022-02-01

- Release workspace-full latest tag built using dazzle v2
- Upgrade to dazzle v2 & use GitHub Actions for build

## 2021-08-01

- Bump Go version to 1.16.6
- Bump rust to 1.54.0
- Bump node.js to v14.17.4
- Bump docker-compose to 1.29.2
- Add golangci-lint
- Add ripgrep
- Add cargo-workspaces to cargo utils
- Add git-lfs

## 2021-06-04

- Bump Go version to 1.16.5
- Bump nvm.sh to v0.38.0
- Introduce pre-commit checks
- Run shellcheck in shell scripts

## 2020-06-03

- Bump Node.js version following a [security alert](https://twitter.com/liran_tal/status/1267519052731289600): [gitpod-io/workspace-images#243](https://github.com/gitpod-io/workspace-images/pull/243)

## 2020-06-02

- Upgrade all Go tools to get the latest `gopls`, and remove broken `golangci-lint` [gitpod-io/workspace-images#237](https://github.com/gitpod-io/workspace-images/pull/237)
- Make Python 3 the default `python` version (use `pyenv local 2.7.17` to go back to Python 2) [gitpod-io/workspace-images#214](https://github.com/gitpod-io/workspace-images/pull/214)

## 2020-05-12

- Downgrade Ruby `2.7.1` → `2.6.6` (because Solargraph doesn't support latest Bundler `2.1.4` yet) [e9281a20](https://github.com/gitpod-io/workspace-images/commit/e9281a207c4c6b4c7df2e91e9ec81f36ed0652ae)

## 2020-05-08

- Upgrade to Rust `1.43.1` [gitpod-io/workspace-images#230](https://github.com/gitpod-io/workspace-images/pull/230)
- Fix the persistence of Ruby gems in `/workspace/.rvm` with a custom `.rvmrc` [gitpod-io/workspace-images#223](https://github.com/gitpod-io/workspace-images/pull/223)
- Upgrade RVM's Ruby from `2.5` → `2.5.8` and `2.6` → `2.7.1` [gitpod-io/workspace-images#213](https://github.com/gitpod-io/workspace-images/pull/213)

## 2020-05-02

- Fix Ubuntu 20.04 based `gitpod/workspace-dotnet` and `gitpod/workspace-dotnet-vnc` images by installing .NET Core SDK 3.1 binaries [gitpod-io/workspace-images#218](https://github.com/gitpod-io/workspace-images/pull/218)

## 2020-04-29

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
