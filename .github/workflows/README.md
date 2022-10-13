# Build, Test, and Publish the Dockerfile

> This folder is intended only for the administrators of the matlab-dockerfile repository. 

The workflow in this folder builds, tests, and publishes a Docker image in GitHub.

## Triggers and Scheduled Jobs

The workflow is scheduled to run every Monday at 00:00.

Additionally, the workflow is triggered each time you push a change in the [`Dockerfile`](../../Dockerfile) or in the [`tests` directory](../../tests) to the repository.

You can also trigger the workflow from the "Actions" tab.

## Push the Image to the GitHub Container Registry

Each time the image passes the qualification, it is pushed to the GitHub Container Registry with the name:

`ghcr.io/mathworks-ref-arch/matlab-dockerfile/matlab:${matlab-release}`

where `${matlab-release}` is a matlab release (e.g. `r2021a`, `r2021b`, etc..) .

## Workflow Description

The workflow consists of a one-dimensional matrix of jobs. Each job builds, tests and publishes the container image for a different MATLAB release, starting from `r2020b`. To ensure that a failure in any job does not cancel other jobs, the `fail-fast` option is set to `false`.

Each job consists of the following steps:

1. Check-out the repository into a GitHub Actions runner.
2. Login to ghcr.io, the GitHub Container Registry.
3. Build the image locally (set the `load` variable to `true`, as suggested in [this example](https://github.com/docker/build-push-action/blob/master/docs/advanced/test-before-push.md)).
4. Install Python and the PyPi packages listed in [`requirements.txt`](../../tests/requirements.txt).
5. Run the tests.
6. Rebuild and push the image to the GitHub Container Registry if the image passed all the tests.
