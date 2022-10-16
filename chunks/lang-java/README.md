# workspace-java-\*

## How to use for a Gitpod workspace

Put the following line in your `.gitpod.yml`:

If you do not have a `.gitpod.yml`, run `gp init` on your terminal to create one.

```yaml
image: gitpod/workspace-java-17
```

Lastly, [see it in action!](https://www.gitpod.io/docs/introduction/learn-gitpod/gitpod-yaml#see-it-in-action)

### Extra docker image variants

We provide multiple variants of the `gitpod/workspace-java-*` docker image as per [chunk.yaml](./chunk.yaml). Each containing a different version of Java:

- `gitpod/workspace-java-11`
- `gitpod/workspace-java-17`

You could use these on your `.gitpod.yml` as well.

## Details

This is mainly optimized for [Java](https://www.java.com/en/), and is based on [workspace-base](../../base/)

The following are installed for you, you can extend using a [custom-docker-image](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-custom-dockerfile) if you wish.

- sdkman
- And with `sdkman`, the following are installed:
    - java-11 or java-17, [depends on the image you're using](#extra-docker-image-variants).
    - gradle
    - maven

### To be aware of

- `GRADLE_USER_HOME` environment variable is set to `/workspace/.gradle`
- Maven local repository is set to `/workspace/.m2-repository`
  > for when a workspace is running (i.e. the user is using it) and also for [custom-docker-image](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-custom-dockerfile) build environment.

---

So that means, if you try to extend this image using a [custom-docker-image](https://www.gitpod.io/docs/configure/workspaces/workspace-image#configure-a-custom-dockerfile) and install things with gradle or maven, those installations will be lost when a workspace starts.
