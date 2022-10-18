# workspace-c

## How to use for a Gitpod workspace

Put the following line in your `.gitpod.yml`:

If you do not have a `.gitpod.yml`, run `gp init` on your terminal to create one.

```yaml
image: gitpod/workspace-c
```

Lastly, [see it in action!](https://www.gitpod.io/docs/introduction/learn-gitpod/gitpod-yaml#see-it-in-action)

## Details

This is mainly optimized for [C](<https://en.wikipedia.org/wiki/C_(programming_language)>), and is based on [workspace-base](../../base/)

The following are installed for you, you can extend using a [custom-docker-image](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-custom-dockerfile) if you wish.

- llvm
- clang
- formatters (i.e. `clang-{format,tidy}`)
- gdb
- lld

For more details, check the [Dockerfile](./Dockerfile)

## Learn more

- Additional resource:
    - https://github.com/gitpod-io/template-c
