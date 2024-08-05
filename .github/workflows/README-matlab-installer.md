# Build and Test the alternates/matlab-installer/Dockerfile

> This folder is intended only for the administrators of the matlab-dockerfile repository.

The workflow in this folder builds and tests the Dockerfile found in `alternates/matlab-installer` using a mocked version of the matlab-installer.

## Triggers and Scheduled Jobs

The workflow is scheduled to run every Monday at 00:00.

Additionally, the workflow is triggered each time you push a change in the [`Dockerfile`](../../alternates/matlab-installer/Dockerfile) or in the [`tests` directory](../../tests) to the repository.

You can also trigger the workflow from the "Actions" tab.

## Workflow Description

This workflow consists of the following steps:

1. Check-out the repository into a GitHub Actions runner.
2. Copy the content of [`test/mocks`](../../tests/alternates/matlab-installer/mocks) into the Docker context directory. These files are required by the [`Dockerfile`](../../alternates/matlab-installer/Dockerfile).
3. Install Python and the PyPi packages listed in [`requirements.txt`](../../tests/tests/requirements.txt).
4. Run the [test file](../../tests/alternates/matlab-installer/test_failing_build.py) to check the messages displayed when the MATLAB installer fails.
5. Build the image with the fake MATLAB installer. The real installer requires a user intervention, thus making it unsuitable for automation.
6. Run the  [test file](../../tests/alternates/matlab-installer/test_mock_matlab_container.py) to check the integration of the fake MATLAB in the Docker image.

---

Copyright 2023-2024 The MathWorks, Inc. All rights reserved.

---
