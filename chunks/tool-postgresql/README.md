# workspace-postgres

## How to use for a Gitpod workspace

Put the following line in your `.gitpod.yml`:

If you do not have a `.gitpod.yml`, run `gp init` on your terminal to create one.

```yaml
image: gitpod/workspace-postgres
```

Lastly, [see it in action!](https://www.gitpod.io/docs/introduction/learn-gitpod/gitpod-yaml#see-it-in-action)

## Details

This is mainly optimized for [PostgreSQL](https://www.postgresql.org/), and is based on [workspace-full](../README.md#workspace-full)

The following are installed for you, you can extend using a [custom-docker-image](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-custom-dockerfile) if you wish.

- A standard postgres 12 installation is included.

For more details, check the [Dockerfile](./Dockerfile)

## To be aware of

The following environment variables are set for you:
	- DATABASE_URL="postgresql://gitpod@localhost"
	- PGHOSTADDR="127.0.0.1"
	- PGDATABASE="postgres"
	- PGWORKSPACE="/workspace/.pgsql"
	- PGDATA="$PGWORKSPACE/data"

PostgreSQL server is initialized and auto-started via a [shell](./Dockerfile#L19) hook after a Gitpod workspace boots.

## Learn more

- Blogs:
    - https://www.gitpod.io/guides/gitpodify#postgresql
