# workspace-mysql

## How to use for a Gitpod workspace

Put the following line in your `.gitpod.yml`:

If you do not have a `.gitpod.yml`, run `gp init` on your terminal to create one.

```yaml
image: gitpod/workspace-mysql
```

Lastly, [see it in action!](https://www.gitpod.io/docs/introduction/learn-gitpod/gitpod-yaml#see-it-in-action)

## Details

This is mainly optimized for [MySQL](https://www.mysql.com/), and is based on [workspace-full](../README.md#workspace-full)

The following are installed for you, you can extend using a [custom-docker-image](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-custom-dockerfile) if you wish.

- A basic `mysql-server` installation

For more details, check the [Dockerfile](./Dockerfile)

## To be aware of

A few things are set to sane values via [mysql.cnf](./mysql.cnf)

MySQL daemon is initialized and auto-started via [this](./mysql-bashrc-launch.sh) shell hook after a Gitpod workspace boots.

## Learn more

- Blogs:
    - https://www.gitpod.io/guides/gitpodify#mysql
