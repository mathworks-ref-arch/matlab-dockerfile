# Building on MATLAB Docker image

The Dockerfile in this subfolder builds on the [MATLAB Container Image on Docker Hub](https://hub.docker.com/r/mathworks/matlab)
by installing MATLAB&reg; toolboxes and support packages using [MATLAB Package Manager (*mpm*)](https://github.com/mathworks-ref-arch/matlab-dockerfile/blob/main/MPM.md).

Use the Dockerfile as an example of how to build a custom image that contains the features of the MATLAB image on Docker&reg; Hub.
These features include accessing the dockerised MATLAB through a browser, batch mode, or an interactive command prompt.
For details of the features in that image, see [MATLAB Container Image on Docker Hub](https://hub.docker.com/r/mathworks/matlab).

### Requirements
* Docker

## Build Instructions

### Get the Dockerfile

Access this Dockerfile either by directly downloading this repository from GitHub&reg;,
or by cloning this repository and
then navigating to the appropriate subfolder.
```bash
git clone https://github.com/mathworks-ref-arch/matlab-dockerfile.git
cd matlab-dockerfile/alternates/building-on-matlab-docker-image
```

### Quick start
Build a container with a name and tag.
```bash
docker build -t matlab_with_add_ons:R2024b .
```

You can then run the container with the "batch" option. Test the container by running an example MATLAB command such as `ver` to display the installed toolboxes.
```bash
docker run --init --rm -e MLM_LICENSE_FILE=27000@MyServerName matlab_with_add_ons:R2024b -batch ver
```
You can check the installed support packages using the MATLAB command `matlabshared.supportpkg.getInstalled`.

You can also run the container with the "browser" option to access MATLAB in a browser.
```bash
docker run --init --rm -it -p 8888:8888 matlab_with_add_ons:R2024b -browser
```
For more information, see [Run the Container](#run-the-container).

## Customize the Image
### Customize Products to Install Using MATLAB Package Manager (mpm)
This Dockerfile installs any specified products
into the MATLAB installation on the MATLAB Docker Hub image.

To customize the build, either pass a list of products into the `ADDITIONAL_PRODUCTS`
argument when building the Docker image, or edit the default value of that argument in the Dockerfile.
The `ADDITIONAL_PRODUCTS` argument must be a space separated list surrounded by quotes.
By default, `ADDITIONAL_PRODUCTS` includes example products, which you can replace.
For example, to build an image containing MATLAB and the Deep Learning Toolbox&trade;:
```bash
docker build --build-arg ADDITIONAL_PRODUCTS="Deep_Learning_Toolbox" -t matlab_with_add_ons:R2024b .
```

For a successful build, include at least one product.
`mpm` automatically installs any toolboxes and support packages
required by the products specified in `ADDITIONAL_PRODUCTS`.
For more information, see [MATLAB Package Manager (*mpm*)](https://github.com/mathworks-ref-arch/matlab-dockerfile/blob/main/MPM.md).

You can modify the products argument of `mpm`, but not the destination folder default value, as this is
set to match that of the MATLAB image on Docker Hub. If this default value for the `--destination` argument is modified, the build may fail.

### Docker Build-Time Variables
The [Dockerfile](https://github.com/mathworks-ref-arch/matlab-dockerfile/blob/main/Dockerfile) supports the following Docker build-time variables:

| Argument Name | Default value | Effect |
|---|---|---|
| [MATLAB_RELEASE](#build-an-image-for-a-different-release-of-matlab) | R2024b | The MATLAB release to install. Must be lower-case, for example: `R2020b`.|
| [ADDITIONAL_PRODUCTS](#customize-products-to-install-using-matlab-package-manager-mpm) | "Symbolic_Math_Toolbox Deep_Learning_Toolbox_Model_for_ResNet-50_Network" | A space separated list of toolboxes and support packages to install. For more details, see  [MATLAB Package Manager](https://github.com/mathworks-ref-arch/matlab-dockerfile/blob/main/MPM.md)|
| [LICENSE_SERVER](#build-an-image-with-license-server-information) | *unset* | The port and hostname of a machine that is running a Network License Manager, using the `port@hostname` syntax. For example: `27000@MyServerName`. To use this build argument, the corresponding lines must be uncommented in the Dockerfile. |

Use these arguments with the `docker build` command to customize the image.
Alternatively, the default values for these arguments can be changed
directly in the Dockerfile.

### Build an Image for a Different Release of MATLAB

For example, to build an image for MATLAB R2022b, use the following command.
```bash
docker build --build-arg MATLAB_RELEASE=R2022b -t matlab_with_add_ons:R2022b .
```

To build an image for MATLAB R2022b with Deep Learning Toolbox and Parallel Computing Toolbox&trade;, use the following command.
```bash
docker build --build-arg MATLAB_RELEASE=R2022b --build-arg ADDITIONAL_PRODUCTS="Deep_Learning_Toolbox Parallel_Computing_Toolbox" -t matlab_with_add_ons:R2022b .
```
For supported releases see [MATLAB Container Image on Docker Hub](https://hub.docker.com/r/mathworks/matlab).
### Build an Image with License Server Information
Including the license server information with the docker build command avoids having to pass it when running the container.
To use this build argument, uncomment the corresponding lines in the Dockerfile.
If those lines are uncommented, `$LICENSE_SERVER` must be a valid license
server or browser mode will not start successfully.

Build container with the License Server.
```bash
docker build -t matlab_with_add_ons:R2024b --build-arg LICENSE_SERVER=27000@MyServerName .
```

Run the container, without needing to pass license information.
```bash
docker run --init matlab_with_add_ons:R2024b -batch ver
```
## Run the Container
The Docker container you build using this Dockerfile inherits run options from its base image.
See the documentation for the base image, [MATLAB Container Image on Docker Hub](https://hub.docker.com/r/mathworks/matlab) (hosted on Docker Hub) for instructions on how to use those features,
which include interacting with MATLAB using a web browser, batch mode, or an interactive command prompt,
as well as how to provide license information when running the container.
Run the commands described there with the name of the Docker image that you build using this Dockerfile.

## More MATLAB Docker Resources
For more MATLAB Docker resources, see [More MATLAB Docker Resources](https://github.com/mathworks-ref-arch/matlab-dockerfile#more-matlab-docker-resources).

## Help Make MATLAB Even Better
You can help improve MATLAB by providing user experience information on how you use MathWorks products. Your participation ensures that you are represented and helps us design better products. To opt out of this service, delete the following line in the Dockerfile:
```Dockerfile
ENV MW_DDUX_FORCE_ENABLE=true MW_CONTEXT_TAGS=$MW_CONTEXT_TAGS,MATLAB:TOOLBOXES:DOCKERFILE:V1
```

To learn more, see the documentation: [Help Make MATLAB Even Better - Frequently Asked Questions](https://www.mathworks.com/support/faq/user_experience_information_faq.html).

## Feedback
We encourage you to try this repository with your environment and provide feedback. If you encounter a technical issue or have an enhancement request, create an issue [here](https://github.com/mathworks-ref-arch/matlab-dockerfile/issues).

----

Copyright 2023-2024 The MathWorks, Inc.

----
