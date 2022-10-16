# workspace-full

## How to use for a Gitpod workspace

Put the following line in your `.gitpod.yml`:

If you do not have a `.gitpod.yml`, run `gp init` on your terminal to create one.

```yaml
image: gitpod/workspace-full
```

Lastly, [see it in action!](https://www.gitpod.io/docs/introduction/learn-gitpod/gitpod-yaml#see-it-in-action)

## Details

The subdirectories here contain several independent `Dockerfile`s built on top of [base](../base/) image. Most of these will be used to build `workspace-full` image[1](../dazzle.yaml#L23).

🔋 `workspace-full` is the most loaded image with tons of common tooling installed.

🎗 It's a compilation of the following resulting individual public docker images built from the subdirectory chunks here each containing a `Dockerfile`:

- [workspace-base](../base/)
- [workspace-c](./lang-c/)
- [workspace-cojure](./lang-clojure/)
- [workspace-go](./lang-go/)
- [workspace-java](./lang-java/)
- [workspace-nix](./tool-nix/)
- [workspace-node](./lang-node/)
- [workspace-python](./lang-python/)
- [workspace-ruby](./lang-ruby/)
- [workspace-rust](./lang-rust/)

Also Used to build `workspace-full` but no individual public docker image is produced for the following:

- [brew](./tool-brew/)
- [nginx](./tool-nginx/)
