# How are these images built?

Here is a short video that shows how this repository works:

[<img alt="How Gitpod's Default Workspace Images are Built" src="https://user-images.githubusercontent.com/599268/106449039-d7dcd780-6483-11eb-91c4-e4e012b9d78b.png" width="600">](https://youtu.be/0lnZak5cCT0)

It briefly explains:
- What are the different Dockerfiles in here?
- How do they relate to each other?
- How does CircleCI build them?
- Which images are built with Dazzle or not (and what's the difference)?
- How to upgrade tools in workspace-full?

# How to contribute?

- Simply open this repository in Gitpod, e.g. by clicking this button:

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/gitpod-io/workspace-images)

- Next, implement your change, and open a Pull Request

- Then, ask a maintainer (for example @jankeromnes) to make CircleCI build your Pull Request

- Finally, once the build passes, test your Pull Request's Docker images on a relevant repository

<br>

> 💡 Tip: CircleCI will upload temporary images to Docker Hub with a special tag, probably something like this: `gitpod/workspace-full:branch-pr-123` (if your Pull Request is number 123).
> 
> You can test this image by editing one of your project's [.gitpod.yml](https://www.gitpod.io/docs/config-gitpod-file/) file like so (maybe on a separate branch):
> 
> ```yml
> image: gitpod/workspace-full:branch-pr-123
> ```
> 
> Finally, once this change is committed and pushed to your repository, you can open the repository or branch in Gitpod to test the project with your new image.

# How to make CircleCI build a PR?

CircleCI only builds branches of [gitpod-io/workspace-images](https://github.com/gitpod-io/workspace-images), not forks, so Pull Requests sent from forks will not have CircleCI builds by default.

But there is a way to make CircleCI build Pull Requests that were sent from a fork.

If you have push access to [gitpod-io/workspace-images](https://github.com/gitpod-io/workspace-images), simply open the PR in Gitpod, and do the following:

```bash
git checkout -b pr-123 # Tip: Use the actual PR number
git push origin pr-123
```

That's it. Simply pushing the Pull Request's commits to a new branch in `origin` is enough to trigger CircleCI for that PR. Pretty soon the build status will appear in the Pull Request automatically.

> 💡 Tip: If CircleCI fails to build a particular image, but you believe it's a temporary problem (e.g. network timeout), you can restart builds directly from CircleCI's UI
