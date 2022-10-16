# workspace-rust

## How to use for a Gitpod workspace

Put the following line in your `.gitpod.yml`:

If you do not have a `.gitpod.yml`, run `gp init` on your terminal to create one.

```yaml
image: gitpod/workspace-rust
```

Lastly, [see it in action!](https://www.gitpod.io/docs/introduction/learn-gitpod/gitpod-yaml#see-it-in-action)

## Details

This is mainly optimized for [Rust](https://www.rust-lang.org/), and is based on [workspace-base](../../base/)

The following are installed for you, you can extend using a [custom-docker-image](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-custom-dockerfile) if you wish.

- A [minimal](./Dockerfile#L11) Rust installation (i.e. only `cargo`, `rustc` and the must have utilities)
- Following `rustup` components:
    - Rust language server (i.e. `rls`)
    - rust-analysis
    - rust-src
    - rustfmt
    - clippy
- Following `cargo` plugins:
    - cargo-watch
    - cargo-edit
    - cargo-workspaces

### To be aware of

`CARGO_HOME` environment variable is set to `/workspace/.cargo` when a workspace is running (i.e. the user is using it).

However, for a [custom-docker-image](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-custom-dockerfile) build environment, `CARGO_HOME` is not set and thus it defaults to `$HOME/.cargo`.
