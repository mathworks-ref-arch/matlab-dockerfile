# Test Strategy

> This folder is intended only for the administrators of the matlab-dockerfile repository. 

The tests in this folder qualify the Docker images built from the [`Dockerfile`](../Dockerfile). 

## Requirements

The tests are implemented in the [Python unit testing framework](https://docs.python.org/3/library/unittest.html) and require Python 3.
To run the tests, you also need these Python packages:

- [The Docker SDK for Python](https://docker-py.readthedocs.io/en/stable/)
- [The TestInfra package](https://testinfra.readthedocs.io/en/latest/)

These packages are pre-installed in the runner. The list of packages that need to be pre-installed is contained in the file [`requirements.txt`](./requirements.txt).

### Environment Variables

To run the tests, set the following environment variables:

| Environment Variable | Example                                 | Notes                                                                                                                                                                                                                  |
| -------------------- | --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `IMAGE_NAME`         | `IMAGE_NAME=matlab-docker-image:r2020a` | The tests will run against the Docker image named `${IMAGE_NAME}`. If no such image is found, the tests will fail.                                                                                         |
| `LICENSE_FILE_PATH`  | `LICENSE_FILE_PATH=path/to/license.lic` | Some tests will attempt to run MATLAB&reg; in the Docker container and require a license file. Store the path to the license file in `${LICENSE_FILE_PATH}` |

## Structure of the Tests

The test classes implement a `SetUpClass` and a `TearDownClass` method.

- The `SetUpClass` method runs before all test methods. This method runs a container from the Docker image with name `${IMAGE_NAME}`.
- The `TearDownClass` method runs after all test methods. This method stops and deletes the container.

## Test Procedure

We identify two kinds of tests: tests which check the file system of the container and tests which run MATLAB in the containers.

### File System Tests

These tests check that:

- all required packages are available
- the `apt` cache is empty
- the `user` is `matlab` and can run `sudo`
- MATLAB is on `PATH` and executable
- no license file is present in the Docker image

These tests do not need any license file mounted in the container.

### MATLAB Tests

These tests check that MATLAB runs correctly in the container. To license MATLAB, a license file is mounted at run-time in the container. The license files are not stored in the repository but are written during the job.

These tests check that:

- MATLAB starts when the container starts.
- the MATLAB&reg; release is consistent with the name/tags of the image.

## Debug

If any of the tests fail, a message is logged in the job logs (see the "Test container" section in the logs). The message log should help you understand the source of the failure.

### Running the tests locally

You can run the tests on a Linux machine that has:

- Docker
- Python 3

To run the tests:

1. Clone this repo.
2. Change current working folder to the matlab-dockerfile folder.
   ```bash
   cd matlab-dockerfile
   ```
3. Build the Docker image that you want to test.
   ```bash
   docker build -t <your_image_name> --build-args MATLAB_RELASE=<r20xxx> .
   ```
   This operation might take a few minutes.
4. Change current working folder to the tests folder.
   ```bash
   cd tests
   ```
5. Set the environment variables.
   ```bash
   export IMAGE_NAME=<your_image_name>
   export LICENSE_FILE_PATH=<path_to_license_file>
   ```
6. Run the full test-suite.
   ```bash
   python3 -m unittest
   ```
   This command runs the test points in all the test files. To run a single test point or tests in a single test file or test class, please use the [unittest CLI](https://docs.python.org/3/library/unittest.html#command-line-interface).
