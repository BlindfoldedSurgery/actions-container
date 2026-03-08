# actions-container

This repository contains a set of reusable workflows geared towards building and working with
container images.

The project follows semantic versioning. You can depend on tags for specific versions of use a
major version tag (e.g. `v1`).

Every commit on the main branch leads to a new release. Releases are managed by
[commitizen][commitizen], which relies on [conventional commits][ccommit]. To make sure you don't
accidentally create commits with an unconventional message, install a pre-commit hook using
`make pre-commit`.

[commitizen]: https://commitizen-tools.github.io/commitizen/

[ccommit]: https://www.conventionalcommits.org/en/v1.0.0/

## Examples

### Build Container and Push on Default Branch

```yaml
jobs:
  build-container-image:
    uses: BlindfoldedSurgery/actions-container/.github/workflows/build-image-buildah.yml@v8
    with:
      push-image: true
```

### Multiplatform Builds

You can build a container for linux/amd64 and linux/arm64 using the
build-dual-image-buildah workflow:

```yaml
jobs:
  build-container-image:
    uses: BlindfoldedSurgery/actions-container/.github/workflows/build-dual-image-buildah.yml@v8
    with:
      push-image: true
```

## Available Jobs

### build-image-buildah

Build a container image using [buildah][buildah] and optionally publish it to the repo's container
registry.

**Inputs:**

| Name                  | Required |             Default              |                Example                | Description                                                                                                                                                                                             |
|:----------------------|:--------:|:--------------------------------:|:-------------------------------------:|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| push-image            |   yes    |                                  |            `true`/`false`             | Whether to push the resulting container image to the registry.                                                                                                                                          |
| runner-name-build     |    no    |          `ubuntu-24.04`          |            `ubuntu-22.04`             | A GitHub runner label to run the build job on. This can be used to select a machine with a specific architecture. **Please note that this only works for repos in the same organization as this repo.** |
| additional-build-args |    no    |                                  |              `key=value`              | Build args that are passed in addition to APP_VERSION                                                                                                                                                   |
| image-name            |    no    |  The slugified repository name   |           `my-cool-project`           | The container image name (without the tag).                                                                                                                                                             |
| version               |    no    | The current commit's SHA1 digest |                `1.2.3`                | The app version. This is used as the container image tag, and is passed an `APP_VERSION` build-arg to the container image build.                                                                        |
| tag-suffix            |    no    |                                  |               `-arm64`                | Appended to the version as the container image tag. Can be used if multiple variants of the same version are built.                                                                                     |
| context               |    no    |               `.`                |              `./subdir`               | The build context directory.                                                                                                                                                                            |
| containerfile         |    no    |           `Dockerfile`           | `example.Dockerfile`, `Containerfile` | The path to the Containerfile/Dockerfile **relative to the repo root**.                                                                                                                                 |
| enable-cache          |    no    |              `true`              |            `true`/`false`             | Whether to use layer caching. Layers are cached in the same registry as the target image.                                                                                                               |
| enable-submodules     |    no    |             `false`              |            `true`/`false`             | Whether to recursively check out Git submodules.                                                                                                                                                        |
| target                |    no    |                                  |                `base`                 | The image stage target to build.                                                                                                                                                                        |
| timeout-minutes       |    no    |              `360`               |                 `120`                 | The timeout for the build job. See [GitHub Actions docs](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idstepstimeout-minutes)                          |

**Outputs:**

|        Name         | Description                            |          Example           |
|:-------------------:|:---------------------------------------|:--------------------------:|
|       digest        | The image's digest                     |     `sha256:12345cafe`     |
|     image-name      | The image's name without the tag       |    `ghcr.io/org/image`     |
|      image-tag      | The image's tag                        |          `v1.2.3`          |
| image-name-with-tag | The combined name and tag of the image | `ghcr.io/org/image:v1.2.3` |

### merge-manifests

Merges a number of already-pushed manifests into one. Useful for multi-architecture image builds.

**Inputs:**

| Name            | Required |             Default              |               Example               | Description                                 |
|:----------------|:--------:|:--------------------------------:|:-----------------------------------:|---------------------------------------------|
| variant-digests |   yes    |                                  | `sha256:1234cafe\nsha256:4321decaf` | A newline-separated list of digests.        |
| image-name      |    no    |  The slugified repository name   |          `my-cool-project`          | The container image name (without the tag). |
| tag             |    no    | The current commit's SHA1 digest |               `1.2.3`               | The container image tag.                    |

**Outputs:**

|        Name         | Description                            |          Example           |
|:-------------------:|:---------------------------------------|:--------------------------:|
|     image-name      | The image's name without the tag       |    `ghcr.io/org/image`     |
|      image-tag      | The image's tag                        |          `v1.2.3`          |
| image-name-with-tag | The combined name and tag of the image | `ghcr.io/org/image:v1.2.3` |

### clean

Build a container image using Docker and optionally publish it to the repo's container registry.

**Inputs:**

| Name                 | Required |            Default            |      Example      | Description                                   |
|:---------------------|:--------:|:-----------------------------:|:-----------------:|-----------------------------------------------|
| image-name           |    no    | The slugified repository name | `my-cool-project` | The container image name (without the tag).   |
| min-versions-to-keep |    no    |             `10`              |                   | The number of most recent versions to keep.   |
| continue-on-error    |    no    |            `true`             |  `true`/`false`   | See [GitHub Actions docs][continue-on-error]. |

[continue-on-error]: https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idcontinue-on-error

[buildah]: https://buildah.io

