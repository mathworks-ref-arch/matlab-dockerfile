# Build, Test and Publish the Dockerfile

This workflow is used to build, test and publish a Docker image in GitHub.

## Triggers and scheduled jobs

The workflow is scheduled to run every Monday at 00:00.

Additionally, a job is triggered every time a change in the [`Dockerfile`](../../Dockerfile) or in the [`tests` directory](../../tests) is pushed to the repository.

The third way to trigger the workflow is by manually triggering it from the "Actions" tab.

## Push the image to the GitHub Container Registry

Every time the image passes the qualification it will be pushed to the GitHub Container Registry with the name:

`ghcr.io/${{github.repository}}/matlab:${{ matrix.matlab-release }}`

where `${{ matrix.matlab-release }}` is a matlab release (e.g. `r2021a`, `r2021b`, etc..) .

## Workflow description

The workflow consists of a one-dimensional matrix of jobs. Each job will build and test the container image for a different matlab release, starting from `r2020b`. A failure in any job should not cancel other jobs, so the `fail-fast` option is set to `false`.

Each job consists of the following steps:

1. Check-out the repository into a GitHub Actions runner;
2. If the image should be pushed to ghcr.io, login to GitHub Container Registry;
3. Build the image locally (set the `load` variable to `true`, as suggested in [this example](https://github.com/docker/build-push-action/blob/master/docs/advanced/test-before-push.md));
4. Install Python and the PyPi packages listed in [`requirements.txt`](../../tests/requirements.txt);
5. Run the tests;
6. If the image should be pushed to ghcr.io, rebuild and push it.
