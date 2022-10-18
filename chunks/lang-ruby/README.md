# workspace-ruby-*

## How to use for a Gitpod workspace

Put the following line in your `.gitpod.yml`:

If you do not have a `.gitpod.yml`, run `gp init` on your terminal to create one.

```yaml
image: gitpod/workspace-ruby-3.1
```

Lastly, [see it in action!](https://www.gitpod.io/docs/introduction/learn-gitpod/gitpod-yaml#see-it-in-action)

### Extra docker image variants

We provide multiple variants of the `gitpod/workspace-ruby-*` docker image as per [chunk.yaml](./chunk.yaml). Each containing a different version of Ruby:

- `gitpod/workspace-ruby-2.7` (This being ruby 2.7.x)
- `gitpod/workspace-ruby-3.0` (This being ruby 3.0.x)
- `gitpod/workspace-ruby-3.1` (This being ruby 3.1.x)

You could use these on your `.gitpod.yml` as well.

## Details

This is mainly optimized for [Ruby](https://www.ruby-lang.org/en/), and is based on [workspace-base](../../base/)

The following are installed for you, you can extend using a [custom-docker-image](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-custom-dockerfile) if you wish.

- We use `rvm`.
    - With `rvm` a complete Ruby runtime is installed in the user-land, the version [depends on the image you're using](#extra-docker-image-variants).
- Some extra packages are installed on the user-land installation with `gem`:
    - bundler, solargraph

For more details, check the [Dockerfile](./Dockerfile)

### To be aware of

- `GEM_HOME` environment variable is set to `/workspace/.rvm`
- `rvm_gems_path` is also set to `/workspace/.rvm` on `~/.rvmrc`
- `/workspace/.rvm` is added to `GEM_PATH` environment variable
  > for when a workspace is running (i.e. the user is using it) and also for [custom-docker-image](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-custom-dockerfile) build environment.

---

So that means, if you try to extend this image using a [custom-docker-image](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-custom-dockerfile) and install things with `gem`, those installations will be lost when a workspace starts.

## Learn more

- Docs:
    - https://www.gitpod.io/docs/introduction/languages/ruby
