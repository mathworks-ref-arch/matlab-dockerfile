# Build and Test the windows/Dockerfile

> This folder is intended only for the administrators of the matlab-dockerfile repository.

The workflow in this folder builds and tests the Dockerfile found in `windows`.

## Triggers and Scheduled Jobs

The workflow is scheduled to run every Monday at 00:00.

Additionally, the workflow is triggered each time you push a change in the [`Dockerfile`](../../windows/Dockerfile) or in the [`tests` directory](../../windows/tests) to the repository.

You can also trigger the workflow from the "Actions" tab.

## Workflow Description

This workflow consists of the following steps:

1. Check-out the repository into a GitHub Actions runner.
1. Run the `Build` target of the [`Makefile.ps1`](../../windows/Makefile.ps1) script to build the [`Dockerfile`].
1. Run the `Test` target of the [`Makefile.ps1`](../../windows/Makefile.ps1) script to test the image built by the previous step.
1. Log into the GitHub Container Registry (GHCR) using the GitHub Actions runner's credentials.
1. Use the `TagImage` target of the  [`Makefile.ps1`](../../windows/Makefile.ps1) script to tag the Docker image with all relevant tags and then use the `Publish` target to push them to the registry.
---

Copyright 2025 The MathWorks, Inc. All rights reserved.

---
