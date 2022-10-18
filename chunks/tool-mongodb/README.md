# workspace-mongodb

## How to use for a Gitpod workspace

Put the following line in your `.gitpod.yml`:

If you do not have a `.gitpod.yml`, run `gp init` on your terminal to create one.

```yaml
image: gitpod/workspace-mongodb
```

Lastly, [see it in action!](https://www.gitpod.io/docs/introduction/learn-gitpod/gitpod-yaml#see-it-in-action)

## Details

This is mainly optimized for [mongodb](https://www.mongodb.com), and is based on [workspace-full](../README.md#workspace-full)

The following are installed for you, you can extend using a [custom-docker-image](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-custom-dockerfile) if you wish.

- A basic `mongodb` installation

For more details, check the [Dockerfile](./Dockerfile)

## To be aware of

An additional dir at `/data/db` is created for you in case you want to use that path.

## Learn more

- Blogs:
    - https://www.gitpod.io/guides/gitpodify#mongodb
