# Build and Test the alternates/building-on-matlab-docker-image/Dockerfile

> This folder is intended only for the administrators of the matlab-dockerfile repository.

The workflow in this folder builds and tests the Dockerfile found in `alternates/building-on-matlab-docker-image`.

## Triggers and Scheduled Jobs

The workflow is scheduled to run every Monday at 00:00.

Additionally, the workflow is triggered each time you push a change in the [`Dockerfile`](../../alternates/building-on-matlab-docker-image/Dockerfile) or in the [`tests` directory](../../tests) to the repository.

You can also trigger the workflow from the "Actions" tab.

## Workflow Description

This workflow consists of the following steps:

1. Check-out the repository into a GitHub Actions runner.
2. Build the image from the Dockerfile.
3. Install Python and the PyPi packages listed in [`requirements.txt`](../../tests/requirements.txt).
4. Run the test files stored in [tests/alternates/building-on-matlab-docker-image](../../tests/alternates/building-on-matlab-docker-image).

---

Copyright 2023-2024 The MathWorks, Inc. All rights reserved.

---
