# workspace-go

## How to use for a Gitpod workspace

Put the following line in your `.gitpod.yml`:

If you do not have a `.gitpod.yml`, run `gp init` on your terminal to create one.

```yaml
image: gitpod/workspace-go
```

Lastly, [see it in action!](https://www.gitpod.io/docs/introduction/learn-gitpod/gitpod-yaml#see-it-in-action)

### Extra docker image variants

We provide multiple variants of the `gitpod/workspace-go` docker image as per [chunk.yaml](./chunk.yaml). Each containing a different version of Go:

- `gitpod/workspace-go:1.18.7`
- `gitpod/workspace-go:1.19.2`

You could use these on your `.gitpod.yml` as well.

## Details

This is mainly optimized for [Go](https://go.dev/), and is based on [workspace-base](../../base/)

The following are installed for you, you can extend using a [custom-docker-image](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-custom-dockerfile) if you wish.

- A standard Go installation
- VS Code Go tools for use with `gopls` as per the [docs](https://github.com/golang/vscode-go/blob/master/docs/tools.md)
    - Also some based on [here](https://github.com/golang/vscode-go/blob/27bbf42a1523cadb19fad21e0f9d7c316b625684/src/goTools.ts#L139)

### To be aware of

`GOPATH` environment variable is set to `/workspace/go` when a workspace is running (i.e. the user is using it).

However, for a [custom-docker-image](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-custom-dockerfile) build environment, `GOPATH` is set to `$HOME/go-packages`.
