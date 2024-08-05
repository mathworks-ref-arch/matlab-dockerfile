# Build and Test the alternates/matlab-container-offline-install/Dockerfile

> This folder is intended only for the administrators of the matlab-dockerfile repository.

The workflow in this folder builds and tests the Dockerfiles found in `alternates/matlab-container-offline-install`.

## Triggers and Scheduled Jobs

The workflow is scheduled to run every Monday at 00:00.

Additionally, the workflow is triggered each time you push a change in the [`archive.Dockerfile`](../../alternates/matlab-container-offline-install/archive.Dockerfile), the [`Dockerfile`](../../alternates/matlab-container-offline-install/Dockerfile) or in the [`tests` directory](../../tests/) to the repository.

You can also trigger the workflow from the "Actions" tab.

## Workflow Description

This workflow consists of the following steps:

1. Check-out the repository into a GitHub Actions runner.
2. Build the archive image.
3. Build the product image, in an offline environment.
4. Install Python and the PyPi packages listed in [`requirements.txt`](../../tests/requirements.txt).
5. Run the test files stored in [tests/alternates/matlab-container-offline-install](../../tests/alternates/matlab-container-offline-install).

---

Copyright 2024 The MathWorks, Inc. All rights reserved.

---
