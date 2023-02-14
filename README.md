# Create a MATLAB Container Image

This repository shows you how to build and customize a Docker container for MATLAB® and its toolboxes, using the [MATLAB Package Manager (*mpm*)](https://github.com/mathworks-ref-arch/matlab-dockerfile/blob/main/MPM.md). 

You can use this container image as a scalable and reproducible method to deploy and test your MATLAB code.

You can also download pre-built images based on this Dockerfile [here](https://github.com/mathworks-ref-arch/matlab-dockerfile/pkgs/container/matlab-dockerfile%2Fmatlab).

### Requirements
* [A Running Network License Manager for MATLAB](https://www.mathworks.com/help/install/administer-network-licenses.html)
    * For more information see section on [Use the Network License Manager](#use-the-network-license-manager) 
* Linux® Operating System
* Docker
* Git

## Build Instructions

### Get Sources
 
```bash
# Clone this repository to your machine
git clone https://github.com/mathworks-ref-arch/matlab-dockerfile.git

# Navigate to the downloaded folder
cd matlab-dockerfile
```

### Build & Run Docker Image
```bash
# Build container with a name and tag of your choice.
docker build -t matlab:r2022b .

# Run the container. Test the container by running an example MATLAB command such as ver.
docker run --rm -e MLM_LICENSE_FILE=27000@MyServerName matlab:r2022b -batch ver
```
The example command `ver` displays the version number of MATLAB and other installed products. For more information, see [ver](https://www.mathworks.com/help/matlab/ref/ver.html). For more information on running the container, see the section on [Run the Container](#run-the-container).

The [Dockerfile](https://github.com/mathworks-ref-arch/matlab-dockerfile/blob/main/Dockerfile) defaults to building a container for MATLAB R2022b.

## Customize the Image
### Customize Products to Install Using MATLAB Package Manager (mpm)
The [Dockerfile](https://github.com/mathworks-ref-arch/matlab-dockerfile/blob/main/Dockerfile) defaults to installing MATLAB with no additional toolboxes or products into the `/opt/matlab` folder.

To customize the build, edit the **mpm** commands in the Dockerfile's usage. You can choose products, release, and destination folder.

Specify products to install as a space-separated list with the `--products` flag, and specify an install path with the `--destination` flag. For more information, see [MPM.md](https://github.com/mathworks-ref-arch/matlab-dockerfile/blob/main/MPM.md).

For example, to build a container with `MATLAB` and `Deep Learning Toolbox` installed under the path `/tmp/matlab`, change the corresponding lines in the Dockerfile as follows:

```Dockerfile
RUN wget -q https://www.mathworks.com/mpm/glnxa64/mpm && \ 
    chmod +x mpm && \
    ./mpm install \
        --release=${MATLAB_RELEASE} \
        --destination=/tmp/matlab \
        --products MATLAB Deep_Learning_Toolbox && \
    rm -f mpm /tmp/mathworks_root.log && \
    ln -s /tmp/matlab/bin/matlab /usr/local/bin/matlab
```

### Customize MATLAB Release and License Server
The [Dockerfile](https://github.com/mathworks-ref-arch/matlab-dockerfile/blob/main/Dockerfile) supports the following Docker build-time variables:

| Argument Name | Default value | Effect |
|---|---|---|
| [MATLAB_RELEASE](#build-an-image-for-a-different-release-of-matlab) | r2022b | The MATLAB release you want to install. Must be lower-case, for example: `r2019b`.|
| [LICENSE_SERVER](#build-an-image-with-license-server-information) | *unset* | The port and hostname of the machine that is running the Network License Manager, using the `port@hostname` syntax. For Example: `27000@MyServerName` |

Use these arguments with the the `docker build` command to customize your image.
Alternatively, you can change the default values for these arguments directly in the [Dockerfile](https://github.com/mathworks-ref-arch/matlab-dockerfile/blob/main/Dockerfile).

#### Build an Image for a Different Release of MATLAB

```bash
# Builds an image for MATLAB R2019b
docker build --build-arg MATLAB_RELEASE=r2019b -t matlab:r2019b .
```

#### Build an Image with License Server Information
Including the license server information with the docker build command avoids having to pass it when running the container.
```bash
# Build container with the License Server
docker build -t matlab:r2022b --build-arg LICENSE_SERVER=27000@MyServerName .

# Run the container, without needing to pass license information
docker run matlab:r2022b -batch ver
```

## Use the Network License Manager
This container requires a Network License Manager to license and run MATLAB. You will need either the port and hostname of the Network License Manager or a `network.lic` file.

**Step 1**: Contact your system administrator who can provide one of:

1. The address to your server, and the port it is running on. 
    For example: `27000@MyServerName.example.com`

2. A `network.lic` file which contains the following lines:
    ```bash
    # Sample network.lic
    SERVER MyServerName.example.com <optional-mac-address> 27000
    USE_SERVER
    ```

3. A `license.dat` file. Open the `license.dat` file, find the `SERVER` line, and either extract the `port@hostname` or create a `network.lic` file by copying the `SERVER` line and adding a `USE_SERVER` line below it.

    ```bash
    # snippet from sample license.dat
    SERVER MyServerName.example.com <mac-address> 27000
    ```
---
**Step 2**: Use `port@hostname` or `network.lic` file with either the `docker build` **or** `docker run` commands.

With the `docker build` command, either:

- Specify the `LICENSE_SERVER` build-arg.

    ```bash
    # Example
    docker build -t matlab:r2022b --build-arg LICENSE_SERVER=27000@MyServerName .
    ```
- Use the `network.lic` file:
    1. Place the `network.lic` file in the same folder as the Dockerfile.
    1. Uncomment the line `COPY network.lic /opt/matlab/licenses/` in the Dockerfile.
    1. Run the docker build command **without** the `LICENSE_SERVER` build-arg:

    ```bash
    # Example
    docker build -t matlab:r2022b .
    ```
    
With the `docker run` command, use the `MLM_LICENSE_FILE` environment variable. For example:

```bash
docker run --rm -e MLM_LICENSE_FILE=27000@MyServerName matlab:r2022b -batch ver
```

## Run the Container
If you did not provide the license server information while building the image, then you must provide it when running the container. Set this environment variable `MLM_LICENSE_FILE` using the `-e` flag with the  network license manager's location as `port@hostname`.

```bash
# Start MATLAB, print version information, and exit:
docker run --rm -e MLM_LICENSE_FILE=27000@MyServerName matlab:r2022b -batch ver
```

You can run the container **without** specifying `MLM_LICENSE_FILE`, if you provided the license server information when building the image, as shown in the examples below.

### Run MATLAB in an Interactive Command Prompt
To start the container and run MATLAB in an interactive command prompt, execute:
```bash
docker run -it --rm matlab:r2022b
```
### Run MATLAB in Batch Mode
To start the container, run a MATLAB command and exit, execute:
```bash
# Container runs the command RAND in MATLAB and exits.
docker run --rm matlab:r2022b -batch rand
```

### Run MATLAB with Startup Options
To override the default behavior of the container and run MATLAB with any set of arguments, such as `-logfile`, execute:
```bash
docker run -it --rm matlab:r2022b -logfile "logfilename.log"
```
To learn more, see the documentation: [Commonly Used Startup Options](https://www.mathworks.com/help/matlab/matlab_env/commonly-used-startup-options.html)


## More MATLAB Docker Resources
* Explore pre-built MATLAB Docker Containers on Docker Hub here: https://hub.docker.com/r/mathworks
    * [MATLAB Containers on Docker Hub](https://hub.docker.com/r/mathworks/matlab) hosts container images for multiple releases of MATLAB.
    * [MATLAB Deep Learning Container Docker Hub repository](https://hub.docker.com/r/mathworks/matlab-deep-learning) hosts container images with toolboxes suitable for Deep Learning.

* Enable additional capabilities using [matlab-deps repository](https://github.com/mathworks-ref-arch/container-images/tree/master/matlab-deps). 
For some workflows and toolboxes, you must specify dependencies. You must do this if you want to do any of the following tasks:
    * Install extended localization support for MATLAB
    * Play media files from MATLAB
    * Generate code from Simulink
    * Use mex functions with gcc, g++, or gfortran
    * Use the MATLAB Engine API for C and Fortran
    * Use the Polyspace 32-bit tcc compiler
    
    The [matlab-deps repository](https://github.com/mathworks-ref-arch/container-images/tree/master/matlab-deps) repository lists Dockerfiles for various releases and platforms. [Click here to view the Dockerfile for R2022b](https://github.com/mathworks-ref-arch/container-images/blob/master/matlab-deps/r2022b/ubuntu20.04/Dockerfile).

    These Dockerfiles contain commented lines with the libraries that support these additional capabilities. Copy and uncomment these lines into your Dockerfile.

## Help Make MATLAB Even Better
You can help improve MATLAB by providing user experience information on how you use MathWorks products. Your participation ensures that you are represented and helps us design better products. To opt out of this service, delete the following line in the Dockerfile:
```Dockerfile
ENV MW_DDUX_FORCE_ENABLE=true MW_CONTEXT_TAGS=MATLAB:DOCKERFILE:V1
```

To learn more, see the documentation: [Help Make MATLAB Even Better - Frequently Asked Questions](https://www.mathworks.com/support/faq/user_experience_information_faq.html).

## Feedback
We encourage you to try this repository with your environment and provide feedback. If you encounter a technical issue or have an enhancement request, create an issue [here](https://github.com/mathworks-ref-arch/matlab-dockerfile/issues).

----

Copyright (c) 2021-2022 The MathWorks, Inc. All rights reserved.

----
