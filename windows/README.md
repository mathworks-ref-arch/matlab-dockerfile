# Create a Windows Container Image for MATLAB

This repository shows you how to build and customize a Windows&reg; Docker&reg; container for MATLAB&reg; and its toolboxes, using the [MATLAB Package Manager](https://github.com/mathworks-ref-arch/matlab-dockerfile/blob/main/MPM.md) (`mpm`) and [MATLAB Batch Licensing (`matlab-batch`)](../alternates/non-interactive/MATLAB-BATCH.md). You can use this container image as a scalable and reproducible method to deploy and test your MATLAB code on a Windows platform.

Use this Dockerfile if you have a MATLAB batch licensing token to license MATLAB in your container. The MATLAB batch licensing project is still in the pilot phase. To inquire about eligibility requirements, fill out this form on the MathWorks&reg; website: [Batch Licensing Pilot Eligibility](https://www.mathworks.com/support/batch-tokens.html).

### Requirements
* MATLAB Batch Licensing Token. For more information, see [Use MATLAB Batch Licensing](../alternates/non-interactive/MATLAB-BATCH.md#matlab-batch-licensing-token).
* Docker Desktop for Windows&reg; (Windows 10 or later) or a Windows Server&reg; build host (Windows Server 2016 or later).

## Build Instructions
### Get the Dockerfile

Access this Dockerfile either by directly downloading this repository from GitHub&reg;, or by cloning this repository and then navigating to the appropriate subfolder.
```bash
git clone https://github.com/mathworks-ref-arch/matlab-dockerfile.git
cd matlab-dockerfile/windows/
```

### Build and Run Docker Image

Build container with a name and tag of your choice.
```powershell
docker build -t matlab-on-windows:R2025a .
```
This [Dockerfile](./Dockerfile) defaults to building a Windows container for MATLAB R2025a. The Dockerfile is based on the Windows base image which contains the full Windows API set. For details, see the documentation on DockerHub for [Windows base image](https://hub.docker.com/r/microsoft/windows).

Test the container by running an example MATLAB command, such as `ver`. The entry point of the container is PowerShell.
```powershell
docker run --rm matlab-on-windows:R2025a matlab-batch "-licenseToken" "user@email.com::encodedToken" "ver"
```
For more information on running the container, see [Run the Container](#run-the-container).

## Customize the Image

By default, the [Dockerfile](Dockerfile) installs the latest available MATLAB release without any additional toolboxes or products, as well as the latest version of [**matlab-batch**](../alternates/non-interactive/MATLAB-BATCH.md).

Use the options below to customize your build.

### Customize MATLAB Release and MATLAB Product List
The [Dockerfile](Dockerfile) supports these Docker build-time variables:

| Argument Name | Default Value | Description |
|---|---|---|
| [MATLAB_RELEASE](#build-an-image-for-a-different-release-of-matlab) | R2025a | MATLAB release to install, for example, `R2023b`. |
| [MATLAB_PRODUCT_LIST](#build-an-image-with-a-specific-set-of-products) | MATLAB | Space-separated list of products to install. For help specifying the products to install, see the "products" input argument on the [documentation page for the mpm install function](https://www.mathworks.com/help/install/ug/mpminstall.html). For example: `MATLAB Simulink Deep_Learning_Toolbox Fixed-Point_Designer` |

Use these arguments with the `docker build` command to customize your image.
Alternatively, the default values for these arguments can be changed directly in the [Dockerfile](Dockerfile).

> Note: MATLAB is installed to `C:\MATLAB` in the Windows container because the default `matlabroot` location can cause issues with compiler products. For details about the issues, see [Build Process Support for File and Folder Names](https://www.mathworks.com/help/coder/ug/enable-build-process-for-folder-names-with-spaces.html) and this [MATLAB Answer](https://www.mathworks.com/matlabcentral/answers/95399-why-is-the-build-process-failing-with-error-code-nmake-fatal-error-u1073-don-t-know-how-to-make). Additionally, you cannot use the suggested 8.3 short file names as a workaround because it is not supported in Windows containers. For details, see this [GitHub issue](https://github.com/microsoft/Windows-Containers/issues/507). 

### Build an Image for a Different Release of MATLAB

For example, to build an image for MATLAB R2021b, use this command.
```powershell
docker build --build-arg MATLAB_RELEASE=R2021b -t matlab-windows:R2021b .
```

For supported releases, see [MATLAB Batch Licensing support](../alternates/non-interactive/MATLAB-BATCH.md#limitations).

### Build an Image with a Specific Set of Products

For example, to build an image with MATLAB and the Statistics and Machine Learning Toolbox&trade;, use this command.
```powershell
docker build --build-arg MATLAB_PRODUCT_LIST="MATLAB Statistics_and_Machine_Learning_Toolbox" -t matlab-stats-windows:R2025a .
```

## Run the Container
To start a container and run MATLAB with a MATLAB batch licensing token, open a Windows PowerShell and enter this command:
```powershell
# Start MATLAB, display 'hello world', and exit.
docker run --rm matlab-on-windows:R2025a matlab-batch -licenseToken 'user@email.com::encodedToken' '\"disp(''hello world'')\"'
```
Note that you must use the rules for using single and double quotation marks in PowerShell. For details, see [about quoting rules](https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_quoting_rules).

Alternatively, you can run a script `myscript.m` containing MATLAB code:

```powershell
# Launch MATLAB, run `myscript.m` and exit:
docker run --mount "type=bind,src=C:\scripts,target=C:\pwd" --workdir "C:\pwd" --rm matlab-on-windows:R2025a matlab-batch -licenseToken 'user@email.com::encodedToken' 'myscript'
```

You can also set your MATLAB batch licensing token at the container level by setting the `MLM_LICENSE_TOKEN` environment variable. For example:

```powershell
# Start MATLAB, display 'hello world', and exit.
docker run -e MLM_LICENSE_TOKEN='user@email.com::encodedToken' --rm matlab-on-windows:R2025a matlab-batch '\"disp(''hello world'')\"'
```

## Feedback
We encourage you to try this repository with your environment and provide feedback. If you encounter a technical issue or have an enhancement request, create an issue [here](https://github.com/mathworks-ref-arch/matlab-dockerfile/issues).

---
Copyright 2025 The MathWorks, Inc.
