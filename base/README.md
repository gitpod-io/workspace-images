# workspace-base

## How to use for a Gitpod workspace

Put the following line in your `.gitpod.yml`:

If you do not have a `.gitpod.yml`, run `gp init` on your terminal to create one.

```yaml
image: gitpod/workspace-base:latest
```

Lastly, [see it in action!](https://www.gitpod.io/docs/introduction/learn-gitpod/gitpod-yaml#see-it-in-action)

## Details

All of the resulting images (from [chunks](../chunks)) are built on top of the `workspace-base` image.

⚡️ This is the most minimal image, used for bootstrapping bigger images. It includes:

- build-essential
- docker
- shells: bash, zsh and fish
- git
- htop, jq, ripgrep
- sudo
- CLI editors such as nano and vim
- tailscale
- And some other must-have tools

For more details, check the [Dockerfile](./Dockerfile)

If you wish to build your custom base image, you can also check our [documentation](https://www.gitpod.io/docs/configure/workspaces/workspace-image#custom-base-image).
