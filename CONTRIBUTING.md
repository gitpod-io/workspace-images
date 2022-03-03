# Contribution Guidelines

## Prerequisite

### Before you start

Before you start on adding a new image you need to get an acknowledgement from the maintainers.
The first step would be to ensure that we already don't have an image or an issue that has the tool/language that you want to add.
After that create an issue explaining how this image would be useful to the community or comment on the existing issue expressing your interest.
One of the maintainers will review the issue and acknowledge if you can work on the issue.

You need to have a gitpod account in order to seamlessly contribute to this repo.


> **NOTE:** Maintainers have access to push branches to this repo whereas the community is expected to fork this repo in order to raise a PR.


## Tools

This repo is already configured with a [.gitpod.yml](.gitpod.yml) which installs and sets up all the required dependency.
It also starts the services that are required to build this repo in dedicated bash shells.

Here is a list of dependencies and tools:

1. [docker](https://docs.docker.com/get-started/overview/) - to start a local registry server
1. [buildkitd](https://github.com/moby/buildkit) - to help build the images
1. [dazzle](https://github.com/gitpod-io/dazzle/) - primary tool used to build docker images
1. [registry image](https://docs.docker.com/registry/deploying/) - a local registry server image

## Building images

## Locally

We ship a shell script [dazzle-up.sh](dazzle-up.sh) that can be used to build the images locally. Run it in a shell:

```bash
./dazzle-up.sh
```

This script will first build the chunks and run tests followed by creation of container images. It uses `dazzle` to perform these tasks.

The images will be pushed to the local registry server running on port 5000. You can pull the images using:

```bash
docker pull localhost:5000/dazzle:combo
```

where `combo` is the name of the combination defined in [dazzle.yaml](dazzle.yaml) e.g. `full`, clojure, postgresql.

> **NOTE:** Building images locally consumes a lot of resources and is often slow.
It might take 1.25 hours to build the images locally.
Subsequent builds are faster if the number modified chunks is less.

## Pipeline

We use [Github Actions](https://docs.github.com/en/actions) for our pipelines.

### Build

We have a Build pipeline which gets triggered on the following two events:

1. **[Build from Main](.github/workflows/push-main.yml)** - On push to the default branch `master`.
1. **[Build from Pull Request](.github/workflows/pull-request.yml)** - On Raising a Pull Request.
If it is raised from a fork then it requires an approval from a maintainer.

A new commit to a PR or the main branch always results in execution of all the tests irrespective of the files modified.
We use caching per branch in order to speed up subsequent builds.
The first push to the Pull Request can take ~1 hr to build.
Subsequent pushes would be faster (~25 mins) depending on the number of chunks modified.

### Release

We have two Release workflows:

1. **[Build from Main](.github/workflows/push-main.yml)** - On push to the default branch `master` release datetimestamp tagged images to dockerhub. Does **NOT** update the `latest` tag
1. **[Update latest tags](.github/workflows/dockerhub-release.yml)** - Weekly update the `latest` tag of all images in dockerhub with current latest datetimestamp image

We do not release any images from pull requests.
All the images are built within GH Actions and tested using dazzle.

As evident from previous sections, we use a single Github Actions Workflow to build and then release the created images.

#### Images

Dazzle builds and stores the images as tags of `localhost:5000/workspace-base-images` image.
We use an internal Google Artifact Registry to further persist and retag the images with proper names and timestamp.

Post the completion of above step we push the images to our [public Docker Hub registry](https://hub.docker.com/u/gitpod).
You can find all the images under `gitpod/`.

## Creating new image

Make sure you have read the [Before you start](#before-you-start) section before proceeding further.

### Adding a chunk

A chunk is categorized broadly in two categories:

1. **lang** - A language chunk such as java, clojure, python etc.
1. **tool** - A tool chunk such as nginx, vnc, postgresql etc.

A chunk should be named following the naming convention `category-name`.
e.g. a java chunk would be named as `lang-java` whereas a postgresql chunk would be named `tool-postgresql`.

Follow the below steps to add your chunk:

1. Create your chunk directory under [./chunks](chunks)
1. Create a `chunk.yaml` file if your chunk has more than one active versions.
You can look at the existing files in this repo for reference e.g. [lang-java](chunks/lang-java/chunk.yaml).
1. Create a docker file containing instructions on how to install the tool.
Make sure you use the default base image like other chunks.

Here is a list of best practices you should keep in mind while adding a chunk:

1. Add variants through `chunk.yaml` if more than one version is popular for the chunk.
e.g. `java-11` and `java-17`.
1. Install specific version of the tool/language.
1. Make sure the user `gitpod` can access the installed tool/lang.
1. The last `USER` command of the image should always be `gitpod` and **NOT** `root`.
1. Always add new path as prefix to existing path.
e.g. `ENV PATH=/my-tool/path/bin:$PATH`.
Not doing so can cause path conflicts and can potentially break other images.
1. **DO NOT** update the default shell rc files like `.bashrc` unless you are making change in the base layer.
1. If you need to create an rc file you should put it in the `.bashrc.d` directory.
All the files are sourced from this directory for a bash session.
e.g. `RUN echo "/etc/mydb/mydb-bashrc-launch.sh" >> /home/gitpod/.bashrc.d/100-my-service-launch.sh`
1. Use `gpg` to unpack and store keyrings and add them to apt sources explicitly.
e.g.

    ```bash
    # fetch keyring over https connection and unpack it using gpg's --dearmor option
    curl -fsSL https://apt.my-secure.org/my-unofficial-repo.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/my-unofficial-repo.gpg.key
    # and then add them to a apt key sources list.
    echo "deb [signed-by=/usr/share/keyrings/my-unofficial-repo.gpg.key] http://apt.my-secure.org/focal/ \
    my-unofficial-repo-toolchain main" | sudo tee /etc/apt/sources.list.d/my-unofficial-repo.list > /dev/null
    ```

### Writing Tests

Follow the instructions below to add tests for a chunk:

1. Create a `category-name.yaml` file under the [tests](tests) directory.
1. Write your tests with proper assertions.
You can read more on how to write tests in the [dazzle documentation](https://github.com/gitpod-io/dazzle/#testing-layers-and-merged-images)

Here is a list of best practices you should keep in mind while writing a test:

1. Test should check the version of the tools and languages and their dependencies that are being installed.
1. Test must assert on the exit code i.e. the `status`.
1. Test must check the existence of directories that are required for the chunk to work.

### Updating dazzle.yml

Adding a combination is easy and only requires you list the base reference and the set of chunks.
You can refer to the existing combinations to learn more.

Here is a list of best practices you should keep in mind while adding a combination:

1. Use a meaningful name of the combination, it should not conflict with existing names.
1. Add `-version` suffix to the combination name if you have variants.
e.g. `ruby-3`
1. Use `base` combination as reference rather than other combination unless there is an exception.
e.g. `full-vnc` is one of the cases which uses the `full` combination rather than the `base`.
This is because the vnc combination only adds an extra `tool-vnc` chunk and nothing else.
This combination should always change whenever the `full` combination changes.

### Updating Release configuration files

The final step to make sure your newly added image gets published is to update these files:

1. **[.github/sync-containers.yml](.github/sync-containers.yml)** : To publish images from local registry to GAR.
1. **[.github/promote-images.yml](.github/promote-images.yml)** : To copy images from GAR to Docker Hub.
