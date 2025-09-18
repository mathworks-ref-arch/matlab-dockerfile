# Create a MATLAB Container Image for Non-Interactive Workflows

The Dockerfile in this subfolder shows you how to build and customize a Docker&reg; container for MATLAB&reg; and its toolboxes, using the [MATLAB Package Manager](../../MPM.md) (`mpm`), and [MATLAB Batch Licensing (via **matlab-batch**)](MATLAB-BATCH.md). Use this Dockerfile if you have a MATLAB batch licensing token to license MATLAB in your container.

The MATLAB batch licensing project is still in the pilot phase. To inquire about eligibility requirements, fill out this form on the MathWorks&reg; website: [Batch Licensing Pilot Eligibility](https://www.mathworks.com/support/batch-tokens.html).

You can use this container image as a scalable and reproducible method to deploy and test your MATLAB code in non-interactive environments.

### Requirements
* [MATLAB Batch Licensing Token](MATLAB-BATCH.md#matlab-batch-licensing-token). For more information, see [Use MATLAB Batch Licensing](#use-matlab-batch-licensing).
* Docker.

## Build Instructions

### Get the Dockerfile

Access this Dockerfile either by directly downloading this repository from GitHub&reg;, or by cloning this repository and then navigating to the appropriate subfolder.

```bash
git clone https://github.com/mathworks-ref-arch/matlab-dockerfile.git
cd matlab-dockerfile/alternates/non-interactive
```

### Quick Start

Build a container with a name and tag.
```bash
docker build -t matlab-non-interactive:R2025b .
```

You can then run the container and use the `matlab-batch` command. Test the container by running an example MATLAB command, such as `rand`. Use the --init flag in the docker run command to ensure that the container stops gracefully when a docker stop or docker kill command is issued.

```bash
docker run --init --rm matlab-non-interactive:R2025b matlab-batch -licenseToken "user@email.com::encodedToken" "rand"
```
For more information, see [Run the Container](#run-the-container).

## Customize the Image

By default, the [Dockerfile](Dockerfile) installs the latest available MATLAB release without any additional toolboxes or products, as well as the latest version of [**matlab-batch**](MATLAB-BATCH.md).

Use the options below to customize your build.

### Docker Build-Time Variables
The [Dockerfile](Dockerfile) supports these Docker build-time variables:

| Argument Name | Default Value | Description |
|---|---|---|
| [MATLAB_RELEASE](#build-an-image-for-a-different-release-of-matlab) | R2025b | MATLAB release to install, for example, `R2023b`. |
| [MATLAB_PRODUCT_LIST](#build-an-image-with-a-specific-set-of-products) | MATLAB | Space-separated list of products to install. For more information, see [MPM.md](../../MPM.md). For example: `MATLAB Simulink Deep_Learning_Toolbox Fixed-Point_Designer` |
| [MATLAB_INSTALL_LOCATION](#build-an-image-with-matlab-installed-to-a-specific-location) | /opt/matlab/R2025b | Path to install MATLAB. |

Use these arguments with the `docker build` command to customize your image.
Alternatively, the default values for these arguments can be changed directly in the [Dockerfile](Dockerfile).

### Build an Image for a Different Release of MATLAB

For example, to build an image for MATLAB R2021b, use this command.
```bash
docker build --build-arg MATLAB_RELEASE=R2021b -t matlab-non-interactive:R2021b .
```

For supported releases, see [MATLAB Batch Licensing support](MATLAB-BATCH.md#limitations).

### Build an Image with a Specific Set of Products

For example, to build an image with MATLAB and the Statistics and Machine Learning Toolbox&trade;, use this command.
```bash
docker build --build-arg MATLAB_PRODUCT_LIST="MATLAB Statistics_and_Machine_Learning_Toolbox" -t matlab-stats-non-interactive:R2025b .
```

### Build an Image with MATLAB installed to a specific location

For example, to build an image with MATLAB installed at `/opt/matlab`, use this command.
```bash
docker build --build-arg MATLAB_INSTALL_LOCATION="/opt/matlab" -t matlab-non-interactive:R2025b .
```

## Use MATLAB Batch Licensing
This container requires a [MATLAB Batch Licensing Token](MATLAB-BATCH.md#matlab-batch-licensing-token) to license MATLAB in non-interactive (batch) workflows. [**matlab-batch**](MATLAB-BATCH.md) licenses all the products contained in the token before running your statement.

Provide the MATLAB Batch Licensing token when calling `matlab-batch`.

With the `docker run` command, use one of these options.

- Specify the `-licenseToken` run-arg.
    ```bash
    # Example
    docker run --init --rm matlab-non-interactive:R2025b matlab-batch -licenseToken "user@email.com::encodedToken" "disp('Hello, World.')"
    ```

- Specify the `MLM_LICENSE_TOKEN` environment variable.
    ```bash
    # Example
    export MLM_LICENSE_TOKEN="user@email.com::encodedToken"
    docker run --init --rm -e MLM_LICENSE_TOKEN matlab-non-interactive:R2025b matlab-batch "disp('Hello, World.')"
    ```

## Run the Container
This Dockerfile's default entry-point is a shell session. After you start the container, use `matlab-batch` to start MATLAB with a MATLAB batch licensing token.

```bash
# Launch MATLAB, print Hello, World., and exit:
docker run --init --rm matlab-non-interactive:R2025b matlab-batch -licenseToken "user@email.com::encodedToken" "disp('Hello, World.')"
```

You can set your MATLAB batch licensing token at the container level by setting the `MLM_LICENSE_TOKEN` environment variable, as shown in the examples below.

### Run a Single MATLAB Statement
To start the container, run a MATLAB command and exit, use this command.
```bash
# Container runs the command RAND in MATLAB and exits.
export MLM_LICENSE_TOKEN="user@email.com::encodedToken"
docker run --init --rm -e MLM_LICENSE_TOKEN matlab-non-interactive:R2025b matlab-batch rand
```

### Run a MATLAB script
To start the container, run a MATLAB script and exit, use this command.
```bash
# Container runs the script myscript.m in MATLAB and exits.
export MLM_LICENSE_TOKEN="user@email.com::encodedToken"
docker run --init --rm -v $(pwd):/content -w /content -e MLM_LICENSE_TOKEN matlab-non-interactive:R2025b matlab-batch "myscript"
```

## More MATLAB Docker Resources
For more resources, see [More MATLAB Docker Resources](../../README.md#more-matlab-docker-resources).

## Help Make MATLAB Even Better
You can help improve MATLAB by providing user experience information on how you use MathWorks products. Your participation ensures that you are represented and helps us design better products. To opt out of this service, delete this in the Dockerfile.
```Dockerfile
ENV MW_DDUX_FORCE_ENABLE=true MW_CONTEXT_TAGS=MATLAB:BATCHLICENSING:DOCKERFILE:V1
```

To learn more, see the documentation: [Help Make MATLAB Even Better - Frequently Asked Questions](https://www.mathworks.com/support/faq/user_experience_information_faq.html).

## Feedback
We encourage you to try this repository with your environment and provide feedback. If you encounter a technical issue or have an enhancement request, create an issue [here](https://github.com/mathworks-ref-arch/matlab-dockerfile/issues).

---
Copyright 2024-2025 The MathWorks, Inc.
