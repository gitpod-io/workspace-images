# workspace-nix

## How to use for a Gitpod workspace

Put the following line in your `.gitpod.yml`:

If you do not have a `.gitpod.yml`, run `gp init` on your terminal to create one.

```yaml
image: gitpod/workspace-nix
```

Lastly, [see it in action!](https://www.gitpod.io/docs/introduction/learn-gitpod/gitpod-yaml#see-it-in-action)

## Details

This is mainly optimized for [Nix](https://nixos.org/), and is based on [workspace-base](../../base/)

The following are installed for you, you can extend using a [custom-docker-image](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-custom-dockerfile) if you wish.

- A standard `nix` installation in multi-user mode.
- `cacheix` and `direnv` is installed globally via `nix-env`

For more details, check the [Dockerfile](./Dockerfile)

## To be aware of

- Nix sandboxing is disabled due to current container limitations
- [`allowUnfree`](https://nixos.wiki/wiki/FAQ/How_can_I_install_a_proprietary_or_unfree_package%3F) is enabled in the config by default.
