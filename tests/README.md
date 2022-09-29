# Test Strategy

The tests contained in this directory aim to qualify the Docker images built from the [`Dockerfile`](../Dockerfile).

## Requirements

The tests are implemented in the [Python unittest testing framework](https://docs.python.org/3/library/unittest.html) and are based on Python 3.
Additional Python packages required to run the tests are:

- [The Docker SDK for Python](https://docker-py.readthedocs.io/en/stable/)
- [The TestInfra package](https://testinfra.readthedocs.io/en/latest/)

These packages are pre-installed in the runner. The list of packages that need to be pre-installed is contained in the file [`requirements.txt`](./requirements.txt).

### Environment Variables

In order to run the tests, the following environment variables have to be set:

| Environment Variable | Example                                 | Notes                                                                                                                                                                                                                  |
| -------------------- | --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `IMAGE_NAME`         | `IMAGE_NAME=matlab-docker-image:r2020a` | The tests will run against the Docker image named `${IMAGE_NAME}`. If no image with such a name is found, the tests will fail.                                                                                         |
| `LICENSE_FILE_PATH`  | `LICENSE_FILE_PATH=path/to/license.lic` | Some tests will attempt to run MATLAB&reg; in the Docker container. In order to do it, a license file should be available in the Docker container and the path to the license file is stored in `${LICENSE_FILE_PATH}` |

The image-under-test is passed to the tests via the environment variable

## Structure of the tests

The test classes implement a `SetUpClass` and a `TearDownClass` method.
The `SetUpClass` method is invoked before all test methods. This method is responsible for running a container from the Docker image with name `${IMAGE_NAME}`.
The `TearDownClass` method is invoked after all test methods. This method is responsible for stopping and deleting the container.

## Test Procedure

We identify two kinds of tests: tests which check the file system of the container and tests which will run MATLAB in the containers.

### File system tests

These tests will check that:

- all required packages are installed;
- the `apt` cache is empty;
- the `user` is `matlab` and that it is allowed to run `sudo`;
- `matlab` is on `PATH` and executable;
- no license file is present in the Docker image.

They will not need any license file to be mounted in the container.

### MATLAB tests

These tests will check that MATLAB runs correctly in the container. In order to license MATLAB, a license file is mounted at run-time in the container. The license files are not stored in the repository as plain files, but they are written on-the-fly in the job.

These test will check that:

- `matlab` is started when the container is started;
- the MATLAB&reg; release is consistent with the name/tags of the image.

## Debug

If some of the tests fail a message will be logged in the job logs (see the "Test container" section in the logs). The message log should help you understanding what's the source of the failure.

### Running the tests locally

You can run the tests on a Linux machine that has:

- Docker
- Python 3

To run the tests:

1. Clone this repo;
2. `cd` into the repo directory:
   ```bash
   cd matlab-dockerfile
   ```
3. Build the Docker image that you want to test:
   ```bash
   docker build -t <your_image_name> --build-args MATLAB_RELASE=<r20xxx> .
   ```
   this operation might take a few minutes;
4. `cd` into the test directory:
   ```bash
   cd tests
   ```
5. Set the following environment variables:
   ```bash
   export IMAGE_NAME=<your_image_name>
   export LICENSE_FILE_PATH=<path_to_license_file>
   ```
6. Run the full test-suite:
   ```bash
   python3 -m unittest
   ```
   this command will run all the test points in all the test files. To run all tests in a test file or all test in a test class or a single test point, please use the [unittest CLI](https://docs.python.org/3/library/unittest.html#command-line-interface).
