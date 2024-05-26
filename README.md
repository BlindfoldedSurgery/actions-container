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
    uses: BlindfoldedSurgery/actions-container/.github/workflows/build-image-docker.yml@v3
    with:
      push-image: ${{ github.ref_name == github.event.repository.default_branch }}
```

### Multiplatform Build Using Matrix

Matrix job outputs are not usable, so we have to work with a dumb hack here and use artifacts.

```yaml
jobs:
  build-images:
    strategy:
      matrix:
        platform: ["arm64", "amd64"]
    uses: BlindfoldedSurgery/actions-container/.github/workflows/build-image-docker.yml@v3
    with:
      digest-artifact-name: digests
      platform: "linux/${{ matrix.platform }}"
      push-image: true
      tag-suffix: -${{ matrix.platform }}

  merge-images:
    needs: build-images
    uses: BlindfoldedSurgery/actions-container/.github/workflows/merge-manifests.yml@v3
    with:
      variant-digests: digests
```

### Multiplatform Build Using Separate Jobs

```yaml
jobs:
  build-image-arm:
    uses: BlindfoldedSurgery/actions-container/.github/workflows/merge-manifests.yml@v3
    with:
      platform: "linux/arm64"
      push-image: true
      tag-suffix: -arm64

  build-image-amd:
    uses: BlindfoldedSurgery/actions-container/.github/workflows/build-image-docker.yml@v3
    with:
      platform: "linux/amd64"
      push-image: true
      tag-suffix: -amd64

  merge-images:
    needs:
      - build-image-arm
      - build-image-amd
    uses: BlindfoldedSurgery/actions-container/.github/workflows/merge-manifests.yml@v3
    with:
      variant-digests: |
        ${{ needs.build-image-arm.outputs.digest }}
        ${{ needs.build-image-amd.outputs.digest }}
```

## Available Jobs

### build-image-docker

Build a container image using Docker and optionally publish it to the repo's container registry.

**Inputs:**

| Name                  | Required |                   Default                   |                   Example                    | Description                                                                                                                                                                            |
|:----------------------|:--------:|:-------------------------------------------:|:--------------------------------------------:|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| push-image            |   yes    |                                             |                `true`/`false`                | Whether to push the resulting container image to the registry.                                                                                                                         |
| additional-build-args |    no    |                                             |                 `key=value`                  | Build args that are passed in addition to APP_VERSION                                                                                                                                  |
| image-name            |    no    |        The slugified repository name        |              `my-cool-project`               | The container image name (without the tag).                                                                                                                                            |
| platform              |    no    |                `linux/amd64`                |                `linux/arm64`                 | The platform to build for (QEMU is used for anything other than the default).                                                                                                          |
| version               |    no    |      The current commit's SHA1 digest       |                   `1.2.3`                    | The app version. This is used as the container image tag, and is passed an `APP_VERSION` build-arg to the container image build.                                                       |
| tag-suffix            |    no    |                                             |                   `-arm64`                   | Appended to the version as the container image tag. Can be used if multiple variants of the same version are built.                                                                    |
| context               |    no    |               the Git context               |    `./subdir`/`{{defaultContext}}:subdir`    | See [docker/build-push-action][context].                                                                                                                                               |
| containerfile         |    no    | the `Dockerfile` in the `context` directory | `subdir/example.Dockerfile`, `Containerfile` | The path to the Containerfile/Dockerfile **relative to the repo root**.                                                                                                                |
| target                |    no    |                                             |                    `base`                    | The image stage target to build.                                                                                                                                                       |
| timeout-minutes       |    no    |                    `360`                    |                    `120`                     | The timeout for the build job. See [GitHub Actions docs](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idstepstimeout-minutes)         |
| digest-artifact-name  |    no    |                                             |                  `digests`                   | If specified, the created digest will be stored in the artifact with the given name. The digest is stored as an empty file with the digest as its name (without the `sha256:` prefix). |

**Outputs:**

|        Name         | Description                            |          Example           |
|:-------------------:|:---------------------------------------|:--------------------------:|
|       digest        | The image's digest                     |     `sha256:12345cafe`     |
|     image-name      | The image's name without the tag       |    `ghcr.io/org/image`     |
|      image-tag      | The image's tag                        |          `v1.2.3`          |
| image-name-with-tag | The combined name and tag of the image | `ghcr.io/org/image:v1.2.3` |

### build-image-kaniko

Build a container image using [kaniko][kaniko] and optionally publish it to the repo's container
registry.

This action is very similar to the one based on Docker, but has two main differences:

- can only build for the platform of the runner machine
- can build images on a runner without any Docker-in-Docker magic

**Inputs:**

| Name                  | Required |             Default              |                Example                | Description                                                                                                                                                                                             |
|:----------------------|:--------:|:--------------------------------:|:-------------------------------------:|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| push-image            |   yes    |                                  |            `true`/`false`             | Whether to push the resulting container image to the registry.                                                                                                                                          |
| runner-name-build     |    no    |         `ubuntu-latest`          |            `ubuntu-22.04`             | A GitHub runner label to run the build job on. This can be used to select a machine with a specific architecture. **Please note that this only works for repos in the same organization as this repo.** |
| additional-build-args |    no    |                                  |              `key=value`              | Build args that are passed in addition to APP_VERSION                                                                                                                                                   |
| image-name            |    no    |  The slugified repository name   |           `my-cool-project`           | The container image name (without the tag).                                                                                                                                                             |
| version               |    no    | The current commit's SHA1 digest |                `1.2.3`                | The app version. This is used as the container image tag, and is passed an `APP_VERSION` build-arg to the container image build.                                                                        |
| tag-suffix            |    no    |                                  |               `-arm64`                | Appended to the version as the container image tag. Can be used if multiple variants of the same version are built.                                                                                     |
| context               |    no    |         the Git context          |              `./subdir`               | See [docker/build-push-action][context].                                                                                                                                                                |
| containerfile         |    no    |           `Dockerfile`           | `example.Dockerfile`, `Containerfile` | The path to the Containerfile/Dockerfile **relative to the context directory**.                                                                                                                         |
| target                |    no    |                                  |                `base`                 | The image stage target to build.                                                                                                                                                                        |
| timeout-minutes       |    no    |              `360`               |                 `120`                 | The timeout for the build job. See [GitHub Actions docs](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idstepstimeout-minutes)                          |
| digest-artifact-name  |    no    |                                  |               `digests`               | If specified, the created digest will be stored in the artifact with the given name. The digest is stored as an empty file with the digest as its name (without the `sha256:` prefix).                  |

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

| Name            | Required |             Default              |                     Example                     | Description                                                                                                                                                             |
|:----------------|:--------:|:--------------------------------:|:-----------------------------------------------:|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| variant-digests |   yes    |                                  | `digests` / `sha256:1234cafe\nsha256:4321decaf` | Either the name of an artifact containing digests as files (see `digest-artifact-name` input of `build-image-docker` workflow), or a newline-separated list of digests. |
| image-name      |    no    |  The slugified repository name   |                `my-cool-project`                | The container image name (without the tag).                                                                                                                             |
| tag             |    no    | The current commit's SHA1 digest |                     `1.2.3`                     | The container image tag.                                                                                                                                                |

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

[context]: https://github.com/docker/build-push-action#git-context

[continue-on-error]: https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idcontinue-on-error

[kaniko]: https://github.com/GoogleContainerTools/kaniko
