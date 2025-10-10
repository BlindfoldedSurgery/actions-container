## v7.4.4 (2025-10-10)

### Fix

- implement buildah build manually

## v7.4.3 (2025-10-10)

### Fix

- **clean**: don't require contents permission

## v7.4.2 (2025-10-09)

### Fix

- remove required permissions from merge-manifests

## v7.4.1 (2025-10-09)

### Fix

- request reuqired permissions for clean and merge

## v7.4.0 (2025-05-26)

### Feat

- **dual-buildah**: re-add custom runner options
- **buildah**: run in container

## v7.3.1 (2025-05-25)

### Fix

- **dual-buildah**: remove custom runner options

## v7.3.0 (2025-05-25)

### Feat

- add dual buildah workflow
- add build-image-buildah

## v7.2.0 (2025-05-23)

### Feat

- **deps**: update gcr.io/kaniko-project/executor docker tag to v1.24.0

## v7.1.1 (2025-04-30)

### Fix

- change syntax of git options

## v7.1.0 (2025-04-30)

### Feat

- add submodule support

## v7.0.0 (2025-01-31)

### Feat

- use GitHub's own hosted ARM runner

## v6.0.0 (2025-01-18)

### BREAKING CHANGE

- build-dual-image-kaniko no longer accepts a digest
artifact name.

### Perf

- Use non-matrix job for dual image build

## v5.2.0 (2025-01-09)

### Feat

- **dual-kaniko**: allow custom amd64 runner

## v5.1.0 (2024-12-27)

### Feat

- Add prebuilt dual arch workflow

## v5.0.1 (2024-12-13)

### Fix

- Cleanup bump PRs correctly

## v5.0.0 (2024-12-13)

### Feat

- Enable kaniko cache by default

## v4.2.2 (2024-12-13)

### Fix

- Don't skip push permission check

## v4.2.1 (2024-12-13)

### Fix

- Don't push cache if no-push is true

## v4.2.0 (2024-12-13)

### Feat

- Add option to enable caching

## v4.1.0 (2024-12-03)

### Feat

- Update runner to ubuntu-24.04

## v4.0.1 (2024-11-24)

### Fix

- Replace deprecated DOCKER_NO_BUILD_SUMMARY arg

## v4.0.0 (2024-11-22)

### Feat

- **deps**: Update rlespinasse/github-slug-action action to v5

## v3.7.4 (2024-10-06)

### Fix

- **deps**: update dependency pre-commit to v4

## v3.7.3 (2024-08-29)

### Fix

- **deps**: update gcr.io/kaniko-project/executor docker tag to v1.23.2

## v3.7.2 (2024-06-30)

### Fix

- Correctly authenticate for private source contexts

## v3.7.1 (2024-06-28)

### Fix

- **build-image-kaniko**: Remove unwanted quotes from APP_VERSION build arg

## v3.7.0 (2024-06-23)

### Feat

- **deps**: update artifact actions to v4

## v3.6.0 (2024-06-23)

### Feat

- Add option to generate Docker build summary

## v3.5.1 (2024-06-08)

### Fix

- **deps**: update gcr.io/kaniko-project/executor docker tag to v1.23.1

## v3.5.0 (2024-05-26)

### Feat

- Add timeout-minutes input

## v3.4.0 (2024-05-26)

### Feat

- Bump version on kaniko updates

## v3.3.0 (2024-03-21)

### Feat

- Add containerfile param to build actions

## v3.2.0 (2023-11-18)

### Feat

- Add image name and tag as outputs

## v3.1.0 (2023-11-12)

### Feat

- Add build workflow using kaniko

## v3.0.4 (2023-11-12)

### Fix

- **build-image-docker**: Check out repo if git context is not used

## v3.0.3 (2023-11-11)

### Fix

- Don't require platform input

## v3.0.2 (2023-11-11)

### Fix

- Only set up QEMU for targeted platform

## v3.0.1 (2023-11-11)

### Fix

- Build image with correct platform if non-amd64 is set

## v3.0.0 (2023-11-11)

### BREAKING CHANGE

- If you relied on the provenance metadata manifest,
this will break your build, because it disables the creation of that.

### Feat

- Add workflow to join multiple images into one
- Add option to store digests as artifact
- Provide image digest as build output
- Add possiblity to specify platform for build-image-docker

## v2.6.0 (2023-11-06)

### Feat

- Add input to specify additional build args
- Add input for target stage

## v2.5.1 (2023-10-21)

### Fix

- Respect image-name input in clean job

## v2.5.0 (2023-10-21)

### Feat

- Allow setting a custom version

### Fix

- Set up buildx in docker build job

## v2.4.0 (2023-10-21)

### Feat

- Allow setting a custom build context

## v2.3.2 (2023-10-21)

### Fix

- Remove typo in build tags expression

## v2.3.1 (2023-10-21)

### Fix

- Try using single quotes around tags

## v2.3.0 (2023-10-21)

### Feat

- Add continue-on-error input for clean action

## v2.2.0 (2023-10-21)

### Feat

- Introduce clean action

## v2.1.0 (2023-10-21)

### Feat

- Accept image-name input for build-image-docker

## v2.0.0 (2023-10-21)

### BREAKING CHANGE

- You'll need to adjust your branch protection rules
if you depend on the status check name.

### Refactor

- Shorten build-container-image to build

## v1.0.1 (2023-10-21)

### Fix

- Remove condition for build-container-image job

## v1.0.0 (2023-10-21)

Initial version.
