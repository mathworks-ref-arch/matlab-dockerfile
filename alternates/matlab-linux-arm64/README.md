# Run MATLAB on Linux ARM in a Container

The MATLAB&reg; Linux&reg; ARM&reg; 64-bit open beta is an early build of MATLAB, Simulink®, and selected toolboxes. 

This guide shows how to download MATLAB, extract it, and mount it into a prebuilt container that contains all of the required dependencies. To instead build your own container image, see
[Build Your Own Image](#build-your-own-image). To install and run MATLAB on a Linux ARM system without using a container, see [MATLAB on Linux ARM (Beta)](https://www.mathworks.com/help/cloudcenter/ug/matlab-on-linux-arm.html).

## Requirements

To run MATLAB in a container, you need:

* An ARM AArch64 processor.
* 8 GB of RAM (minimum). 16 GB of RAM (recommended).
* 15 GB of storage. An SSD is strongly recommended.
* A Linux operating system.
* Docker&reg;.

## Sign Up and Download Software

To sign up for the beta, go to [MATLAB R2026b Linux ARM 64 Open Beta](https://www.mathworks.com/support/aarch64-r2026b-beta.html), complete the sign up form, and accept the Software Licensing Agreement. Then click the link provided to download the `.tar.gz` archive.

## Run MATLAB in a Container

To run MATLAB in a container, follow these steps:

1. Extract the contents of the `.tar.gz` archive into a dedicated folder. These commands use the `/opt/matlab` folder and version 3.1.1 of the archive, but the version number is subject to change.
    ```bash
    sudo mkdir -p /opt/matlab
    sudo tar -xf MATLABR2026b_OpenBeta_aarch64_v3.1.1.tar.gz -C /opt/matlab
    ```

2. Run the prebuilt Docker image and mount the extracted files into the `/opt/matlab` folder inside the container. The first time you run this command, Docker pulls the image from the GitHub&reg; container repository.
    ```bash
    docker run --init -it --rm \
    -v /opt/matlab:/opt/matlab:ro \
    ghcr.io/mathworks-ref-arch/matlab-dockerfile/matlab-arm64:r2026b-ubuntu26.04
    ```
    This starts MATLAB in an interactive command prompt with an Ubuntu 26.04 base image. For information about using alternative base operating systems and startup options, see the following sections.
    > **Tip**
    >
    > To give the container access to the GPUs on your system, include `-gpus all` in your Docker run command. For more information, see [Use GPUs in Containers](https://www.mathworks.com/help/cloudcenter/ug/use-gpus-in-containers.html).

## Use an Image with a Different Base Operating System

The base operating system of the container image is independent of the operating system on the host machine. For example, you can run an Ubuntu image on a Red Hat host machine.

MathWorks&reg; publishes prebuilt images for several base operating systems, following the naming scheme `matlab-arm64:<release>-<os>`. Modify your `docker run` command to use your desired tag.


| Image tag             | Operating system    | Supports MATLAB in a browser |
|-----------------------|---------------------|------------------------------|
| `r2026b-ubuntu26.04`  | Ubuntu 26.04        | Yes                          |
| `r2026b-ubuntu24.04`  | Ubuntu 24.04        | Yes                          |
| `r2026b-ubuntu22.04`  | Ubuntu 22.04        | Yes                          |
| `r2026b-debian13`     | Debian 13           | Yes                          |
| `r2026b-debian12`     | Debian 12           | Yes                          |
| `r2026b-ubi10`        | Red Hat&reg; UBI 10 | No                           |
| `r2026b-ubi9`         | Red Hat UBI 9       | No                           |
| `r2026b-ubi8`         | Red Hat UBI 8       | No                           |

Only the Ubuntu and Debian images support running MATLAB in a browser using [MATLAB Proxy](https://github.com/mathworks/matlab-proxy).

## Run MATLAB in a Browser with MATLAB Proxy

To run MATLAB in a browser with an Ubuntu or Debian image, modify your `docker run` command to expose port 8888 for the web browser connection and specify `matlab-proxy-app` as the entry point.
```bash
docker run --init -it --rm -p 8888:8888 \
  -v /opt/matlab:/opt/matlab:ro \
  --entrypoint matlab-proxy-app \
  ghcr.io/mathworks-ref-arch/matlab-dockerfile/matlab-arm64:r2026b-ubuntu26.04
```

You can then access MATLAB by opening the URL (by default `http://localhost:8888`) printed to the terminal.

## Run MATLAB in Batch Mode

To run a MATLAB script, statement, or function non-interactively, add `-batch` followed by the MATLAB code to run. For example, this command runs the script `myscript`.

```bash
docker run --init --rm \
  -v /opt/matlab:/opt/matlab:ro \
  ghcr.io/mathworks-ref-arch/matlab-dockerfile/matlab-arm64:r2026b-ubuntu26.04 -batch myscript
```

## Build Your Own Image

Instead of using the prebuilt image, you can build your own image that you can use to run MATLAB on Linux ARM. Use these steps only if you need to build your own image, for example if you need to customize the image.

### Additional Requirements

In addition to the [requirements](#requirements) above, to build the image you also need:

* A Docker environment with BuildKit enabled. This is the default in current Docker releases.

### Sign Up and Download Software

To sign up for the beta, go to [MATLAB R2026b Linux ARM 64 Open Beta](https://www.mathworks.com/support/aarch64-r2026b-beta.html), complete the sign up form, and accept the Software Licensing Agreement. Then click the link provided to download the `.tar.gz` archive.

### Build Container Image Without MATLAB Installed
Follow these steps to build and use an image that, like the prebuilt images, requires you to mount MATLAB at run time:
1. Access the Dockerfile either by directly downloading this repository from GitHub, or by cloning this repository and then navigating to the appropriate subfolder.
    ```bash
    git clone https://github.com/mathworks-ref-arch/matlab-dockerfile.git
    cd matlab-dockerfile/alternates/matlab-linux-arm64
    ```
2. Build the image. By default, the Dockerfile builds on a prebuilt Ubuntu 26.04 base image.
    ```bash
    docker build -t matlab:r2026b-ubuntu26.04-arm64 .
    ```
3. Run the image and mount the extracted files into a folder inside the container.
    ```bash
    docker run --init -it --rm \
    -v /opt/matlab:/opt/matlab:ro \
    matlab:r2026b-ubuntu26.04-arm64
    ```
    This starts MATLAB in an interactive command prompt, but you can alternatively run MATLAB in a browser or in batch mode, as described above.
    

### Build Container Image With MATLAB Installed

1. Access the Dockerfile either by directly downloading this repository from GitHub, or by cloning this repository and then navigating to the appropriate subfolder.

    ```bash
    git clone https://github.com/mathworks-ref-arch/matlab-dockerfile.git
    cd matlab-dockerfile/alternates/matlab-linux-arm64
    ```
2. Move the `.tar.gz` archive into the `matlab-archive` folder inside `matlab-linux-arm64`.
    > **Note**: Do not extract the archive.
3. Build the image. By default, the Dockerfile builds on a prebuilt Ubuntu 26.04 base image.
    ```bash
    docker build -t matlab:r2026b-ubuntu26.04-arm64 .
    ```
4. Run the image. 
    ```bash
    docker run --init -it --rm matlab:r2026b-ubuntu26.04-arm64
    ```
    This starts MATLAB in an interactive command prompt, but you can alternatively run MATLAB in a browser or in batch mode, as described above.

### Build with a Different Base Image

By default, the Dockerfile builds on a prebuilt Ubuntu 26.04 base image. To build on a different operating system, set the `OS` build argument to any operating system listed in the [Use an Image with a Different Base Operating System](#use-an-image-with-a-different-base-operating-system) table. For example, use this command to build on a Red Hat UBI 9 base image.

```bash
docker build --build-arg OS=ubi9 -t matlab:r2026b-ubi9-arm64 .
```

### Customize the Image

To customize your image, you can use the following optional arguments with the `docker build` command by specifying them after `--build-arg`.

| Argument | Default value | Description |
|---|---|---|
| `OS` | `ubuntu26.04` | Sets the operating system of the base image. For more information, see [Build with a Different Base Image](#build-with-a-different-base-image). |
| `MATLAB_TGZ` | `MATLABR2026b_OpenBeta_aarch64_v3.1.1.tar.gz` | The file name of the MATLAB `tar.gz` archive in the `matlab-linux-arm64/matlab-archive` folder. |
| `PIP_INDEX_URL` | *unset* | A custom pip package index URL, for example a private PyPI mirror. Leave unset to install matlab-proxy from the public Python Package Index. |


## More MATLAB Docker Resources
For more MATLAB Docker resources, see [More MATLAB Docker Resources](../../README.md#more-matlab-docker-resources).

## Help Make MATLAB Even Better
You can help improve MATLAB by providing user experience information on how you use MathWorks products. Your participation ensures that you are represented and helps us design better products. To opt out of this service, set the environment variable `MW_DDUX_FORCE_ENABLE` to `false` when you run the container.
```bash
docker run --init -it --rm \
-e MW_DDUX_FORCE_ENABLE=false \
-v /opt/matlab/R2026b_OpenBeta:/opt/matlab:ro \
ghcr.io/mathworks-ref-arch/matlab-dockerfile/matlab-arm64:r2026b-ubuntu26.04
```
If you build your own image, you can opt out by deleting this line in the Dockerfile.
```bash
ENV MW_DDUX_FORCE_ENABLE=true MW_CONTEXT_TAGS=MATLAB:ARM64:DOCKERFILE:V1
```

To learn more, see the documentation: [Help Make MATLAB Even Better - Frequently Asked Questions](https://www.mathworks.com/support/faq/user_experience_information_faq.html).

## Feedback
We encourage you to try this repository with your environment and provide feedback. If you encounter a technical issue or have an enhancement request, create an issue [here](https://github.com/mathworks-ref-arch/matlab-dockerfile/issues).

----
Copyright 2026 The MathWorks, Inc.

----