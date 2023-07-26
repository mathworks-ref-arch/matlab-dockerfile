# Build and Test the alternates/building-on-matlab-docker-image/Dockerfile

> This folder is intended only for the administrators of the matlab-dockerfile repository.

The workflow in this folder builds and tests the Dockerfile found in `alternates/building-on-matlab-docker-image`.

## Triggers and Scheduled Jobs

The workflow is scheduled to run every Monday at 00:00.

Additionally, the workflow is triggered each time you push a change in the [`Dockerfile`](../../alternates/building-on-matlab-docker-image/Dockerfile) or in the [`tests` directory](../../tests/alternates/building-on-matlab-docker-image) to the repository.

You can also trigger the workflow from the "Actions" tab.

## Workflow Description

This workflow consists of the following steps:

1. Check-out the repository into a GitHub Actions runner.
2. Install Python and the PyPi packages listed in [`requirements.txt`](../../tests/requirements.txt).
3. Run the [test file](../../tests/alternates/building-on-matlab-docker-image/test_build.py) to check the messages displayed during the build phase.
4. Build the image from the Dockerfile.
5. Run the other test files stored in [tests/alternates/matlab-installer](../../tests/alternates/matlab-installer).

---

Copyright (c) 2023 The MathWorks, Inc. All rights reserved.

---
