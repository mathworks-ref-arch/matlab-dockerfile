# Install MATLAB and Add-Ons in Containers in an Offline Environment

The Dockerfiles in this subfolder show you how to build and customize a Docker&reg; container for MATLAB&reg; and its toolboxes, using the [MATLAB Package Manager (*mpm*)](../../MPM.md) in an offline environment where *mpm* is not able to download the toolbox installation files. Use this solution only if you need to install MATLAB, toolboxes, and support packages in an air-gapped environment. Otherwise, use the [`Dockerfile`](../../Dockerfile) in the top-level repository.

The solution uses two Docker images. The first image (archive image) contains the installation files that are required by *mpm* to install from source. The second image (product image) uses the archive image to get the installation files for MATLAB, toolboxes and support packages that you want to install.

### Requirements
* [A Running Network License Manager for MATLAB](https://www.mathworks.com/help/install/administer-network-licenses.html)
    * For more information, see [Use the Network License Manager](../../README.md#use-the-network-license-manager)
* Docker >= 20.10

## Build Instructions

### Get the Dockerfiles

Access the Dockerfiles either by directly downloading this repository from GitHub&reg;, or by cloning this repository and then navigating to the appropriate subfolder. You must have a working internet connection to perform this action.

```bash
git clone https://github.com/mathworks-ref-arch/matlab-dockerfile.git
cd matlab-dockerfile/alternates/matlab-container-offline-install
```
### Build the Archive Docker Image
> :warning: Note: You must run this step in an online environment.

You can then store the generated Docker build and copy it to the offline or air-gapped environment for the next step.

Build the archive image with a name and tag.
```bash
docker build -t mpm-archive:R2025a -f archive.Dockerfile .
```

By default, the [archive.Dockerfile](archive.Dockerfile) downloads the latest available MATLAB release without any additional toolboxes or products.

To customize the build of the archive image, refer to [Customize the Archive Docker Image](#customize-the-archive-docker-image).

### Build the Product Docker Image
To run this step in an offline or air-gapped environment, you need:
* The [mathworks/matlab-deps](https://hub.docker.com/r/mathworks/matlab-deps) image in your local Docker registry.
* The mpm-archive image in your local Docker registry.
* A Docker environment with [BuildKit enabled](https://docs.docker.com/build/buildkit/#getting-started).

Build a container with a name and tag.
```bash
DOCKER_BUILDKIT=1 docker build -t matlab-from-source:R2025a .
```

To customize the build of the product image, refer to [Customize the Product Docker Image](#customize-the-product-docker-image).

## Customization Instructions
Follow these instructions if you want to customize the build of the archive and product Docker images.

### Customize the Archive Docker Image
The [archive.Dockerfile](archive.Dockerfile) supports the following Docker build-time variables:

| Argument Name | Default value | Effect |
|---|---|---|
| [MATLAB_RELEASE](#build-an-archive-image-for-a-different-release-of-matlab) | R2025a | The MATLAB release to install, for example, `R2023b`. |
| [MATLAB_PRODUCT_LIST](#build-an-archive-image-with-a-specific-set-of-products) | MATLAB | Products to install as a space-separated list. For more information, see [MPM.md](../../MPM.md). For example: `MATLAB Simulink Deep_Learning_Toolbox Fixed-Point_Designer` |

Use these arguments with the `docker build` command to customize your image.
Alternatively, you can change the default values for these arguments directly in the [archive.Dockerfile](archive.Dockerfile).

#### Build an Archive Image for a Different Release of MATLAB

For example, to build an archive image for MATLAB R2023b installation files, use the following command.
```bash
docker build --build-arg MATLAB_RELEASE=R2023b -t mpm-archive:R2023b -f archive.Dockerfile .
```

#### Build an Archive Image with a specific set of products

For example, to build an image with MATLAB and the Statistics and Machine Learning Toolbox&trade; installation files, use this command.
```bash
docker build --build-arg MATLAB_PRODUCT_LIST="MATLAB Statistics_and_Machine_Learning_Toolbox" -t mpm-archive:R2025a -f archive.Dockerfile .
```

### Customize the Product Docker Image
The [Dockerfile](Dockerfile) supports the following Docker build-time variables:

| Argument Name | Default value | Effect |
|---|---|---|
| [MATLAB_RELEASE](#build-an-image-for-a-different-release-of-matlab) | R2025a | The MATLAB release you want to install, in lower-case. For example: `R2022a`. :warning: This release must match the `MATLAB_RELEASE` you use to build the archive image. |
| [MATLAB_PRODUCT_LIST](#build-an-image-with-a-specific-set-of-products) | MATLAB | Products to install as a space-separated list. For more information, see [MPM.md](../../MPM.md). For example: `MATLAB Simulink Deep_Learning_Toolbox Fixed-Point_Designer`. The list of products to install must be a subset of the installation files available in the archive image. |
| [MATLAB_INSTALL_LOCATION](#build-an-image-with-matlab-installed-to-a-specific-location) | /opt/matlab/R2025a | The path to install MATLAB. |
| [ARCHIVE_BASE_IMAGE](#build-an-image-from-a-different-archive) | mpm-archive:R2025a | The name of the Docker&reg; image containing the product installation files. |
| [LICENSE_SERVER](#build-an-image-configured-to-use-a-license-server) | *unset* | The port and hostname of the machine that is running the Network License Manager, using the `port@hostname` syntax. For example: `27000@MyServerName` |

Use these arguments with the `docker build` command to customize your image.
Alternatively, you can change the default values for these arguments directly in the [Dockerfile](Dockerfile).


### Build an Image for a Different Release of MATLAB

For example, to build an image for MATLAB R2023b, use the following command.
```bash
docker build --build-arg MATLAB_RELEASE=R2023b --build-arg ARCHIVE_BASE_IMAGE=mpm-archive:R2023b -t matlab-from-source:R2023b .
```
Ensure that the release of the archive base image you set in `ARCHIVE_BASE_IMAGE` matches the one in `MATLAB_RELEASE`.

### Build an Image with a Specific Set of Products

For example, to build an image with MATLAB and the Statistics and Machine Learning Toolbox, use this command.
```bash
docker build --build-arg MATLAB_PRODUCT_LIST="MATLAB Statistics_and_Machine_Learning_Toolbox" -t matlab-stats-from-source:R2025a .
```

### Build an Image with MATLAB Installed to a Specific Location

For example, to build an image with MATLAB installed at `/opt/matlab`, use this command.
```bash
docker build --build-arg MATLAB_INSTALL_LOCATION="/opt/matlab" -t matlab-from-source:R2025a .
```

### Build an Image from a Different Archive

For example, to build an image using a different archive image, use the following command.
```bash
docker build  --build-arg ARCHIVE_BASE_IMAGE=my-archive -t matlab-from-source:R2025a .
```

#### Build an Image Configured to Use a License Server

Including the license server information with the `docker build` command means you do not have to pass it when running the container.
```bash
# Build container with the License Server.
docker build --build-arg LICENSE_SERVER=27000@MyServerName -t matlab-from-source:R2025a .

# Run the container, without needing to pass license information.
docker run --init --rm matlab-from-source:R2025a -batch ver
```

For more information, see [Use the Network License Manager](../../README.md#use-the-network-license-manager).

## More MATLAB Docker Resources
For more MATLAB Docker resources, see [More MATLAB Docker Resources](../../README.md#more-matlab-docker-resources).

## Help Make MATLAB Even Better
You can help improve MATLAB by providing user experience information on how you use MathWorks products. Your participation ensures that you are represented and helps us design better products. To opt out of this service, delete the following line in the Dockerfile:
```Dockerfile
ENV MW_DDUX_FORCE_ENABLE=true MW_CONTEXT_TAGS=MATLAB:FROM_SOURCE:DOCKERFILE:V1
```

To learn more, see the documentation: [Help Make MATLAB Even Better - Frequently Asked Questions](https://www.mathworks.com/support/faq/user_experience_information_faq.html).

## Feedback
We encourage you to try this repository with your environment and provide feedback. If you encounter a technical issue or have an enhancement request, create an issue [here](https://github.com/mathworks-ref-arch/matlab-dockerfile/issues).

---
Copyright 2024-2025 The MathWorks, Inc.
