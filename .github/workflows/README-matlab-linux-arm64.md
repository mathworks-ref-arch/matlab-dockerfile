# Build, Test, and Publish the Linux ARM64 Dockerfile

> This folder is intended only for the administrators of the matlab-dockerfile repository.

The workflow in this folder builds, tests, and publishes the prebuilt Linux ARM64 images for the Dockerfile found in `alternates/matlab-linux-arm64`. These images do not contain MATLAB; users mount their own MATLAB installation at run time, as described in the [alternate's README](../../alternates/matlab-linux-arm64/README.md).

## Triggers and Scheduled Jobs

The workflow is scheduled to run every Monday at 00:00. The weekly rebuild picks up new `matlab-proxy` releases and updates to the `matlab-deps` base images.

Additionally, the workflow is triggered each time you push a change in the [`Dockerfile`](../../alternates/matlab-linux-arm64/Dockerfile) or in the workflow file itself to the repository.

You can also trigger the workflow from the "Actions" tab.

## Push the Image to the GitHub Container Registry

Each time the image passes the smoke test, it is pushed to the GitHub Container Registry with the name:

`ghcr.io/mathworks-ref-arch/matlab-dockerfile/matlab-arm64:${matlab-release}-${os}`

where `${matlab-release}` is the MATLAB release and `${os}` is the base operating system (e.g. `ubuntu26.04` or `ubi9`). Each image is published under both release casings, e.g. `r2026b-ubuntu26.04` and `R2026b-ubuntu26.04`, matching the corresponding [`matlab-deps-arm64`](https://github.com/mathworks-ref-arch/container-images/pkgs/container/container-images%2Fmatlab-deps-arm64) base image tags.

## Workflow Description

The workflow consists of a matrix of jobs, one per MATLAB release and base operating system. To ensure that a failure in any job does not cancel other jobs, the `fail-fast` option is set to `false`. The jobs run on a native ARM64 runner (`ubuntu-24.04-arm`).

Each job consists of the following steps:

1. Check-out the repository into a GitHub Actions runner.
2. Free up disk space on the runner.
3. Compute the base image tag and the published image tag from the MATLAB release and operating system.
4. Login to ghcr.io, the GitHub Container Registry.
5. Build the image locally, using the matching `matlab-deps-arm64` image as the base.
6. Smoke-test the image: confirm that the `matlab` launcher symlink is present and, on the Ubuntu and Debian images, that `matlab-proxy-app` is on the `PATH`. The UBI images are command-line only, so this check is skipped for them.
7. Push the image to the GitHub Container Registry if it passed the smoke test.

---

Copyright 2026 The MathWorks, Inc. All rights reserved.

---
