# workspace-node

## How to use for a Gitpod workspace

Put the following line in your `.gitpod.yml`:

If you do not have a `.gitpod.yml`, run `gp init` on your terminal to create one.

```yaml
image: gitpod/workspace-node
```

Lastly, [see it in action!](https://www.gitpod.io/docs/introduction/learn-gitpod/gitpod-yaml#see-it-in-action)

### Extra docker image variants

We provide multiple variants of the `gitpod/workspace-node` docker image as per [chunk.yaml](./chunk.yaml). Each containing a different version of Node:

- `gitpod/workspace-node` (This being node 18)
- `gitpod/workspace-node-lts` (This being node 16, hence LTS)

You could use these on your `.gitpod.yml` as well.

## Details

This is mainly optimized for [Node](https://nodejs.org/), and is based on [workspace-base](../../base/)

The following are installed for you, you can extend using a [custom-docker-image](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-custom-dockerfile) if you wish.

- nvm (node version manager)
- And with `nvm`, a `node` version is installed, [depends on the image you're using](#extra-docker-image-variants).
- With `npm`, the following are installed:
    - typescript
    - yarn
    - pnpm
    - node-gyp
- [Google Chrome](../tool-chrome/) for headless use.

For more details, check the [Dockerfile](./Dockerfile)

## Learn more

- Docs:
    - https://www.gitpod.io/docs/introduction/languages/javascript
