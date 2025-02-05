# Create MATLAB Container Image Using MATLAB Installer

This repository demonstrates how to create a Docker&reg; container image for MATLAB&reg; from local files using the MATLAB installer on a Linux&reg; Operating System. To create a container image for other operating systems, use the appropriate commands. This method provided here uses the MATLAB installer rather than [MATLAB Package Manager (`mpm`)](../../MPM.md). The MATLAB installer is the default graphical installer for MATLAB.

The Dockerfile in this subfolder shows you how to use the MATLAB installer with the `-mode silent` flag to install MATLAB without a graphical user interface. Use this Dockerfile if either of these conditions apply.

- You need toolboxes that `mpm` cannot install.
- You prefer using the MATLAB installer workflow, for example, if you have already set it up in your CI/CD pipeline.

If not, use the [simpler workflow](../../README.md) to build a container image using `mpm`.

Use the container image as a scalable and reproducible method to deploy MATLAB in a variety of situations, including clouds and clusters.

## Requirements

- Docker

- Git&trade;

## Step 1. Clone This Repository

1. Clone this repository using this command.

```bash
git clone https://github.com/mathworks-ref-arch/matlab-dockerfile.git
```

2. Inside the cloned repository, navigate to the `alternates/matlab-installer` folder.
3. Create a subfolder named `matlab-install`.

## Step 2. Choose MATLAB Installation Method

To install MATLAB into the container image, choose a MATLAB installation method. You can either use MATLAB installation files or a MATLAB ISO image.

### MATLAB Installation Files

To obtain the installation files, you must be an administrator for the license linked with your MathWorks&reg; account.

1. From the [MathWorks Downloads](https://www.mathworks.com/downloads/) page, select the desired version of MATLAB.
1. Download the Installer for Linux.
1. Follow the steps at [Download Products Without Installation](https://www.mathworks.com/help/install/ug/download-without-installing.html).
1. Specify the location of the `matlab-install` subfolder of the cloned repository as the path to the download folder.
1. Select the installation files for the Linux (64-bit) version of MATLAB.
1. Select the products you want to install in the container image.
1. Confirm your selections and complete the download.
1. **(For MATLAB releases after R2020a)** The installation files are extracted automatically into a subfolder with a date stamp. Move these files up a level using this command from the `matlab-installer` folder.

```bash
mv ./matlab-install/<Time Stamp>/* ./matlab-install/
```

### MATLAB ISO

1. From the [MathWorks Downloads](https://www.mathworks.com/downloads/) page, select the desired version of MATLAB.
1. Next to the text "I WANT TO:" click on the dropdown and select "Get ISOs and DMGs".
1. Download the Linux ISO image for your desired release of MATLAB.
1. Extract the ISO into the `matlab-install` subfolder of the cloned repository.
1. The permissions are not setup correctly on files extracted from an ISO downloaded from MathWorks. To remedy this, run the following command from the `alternates/matlab-installer` folder in the repository.

```bash
chmod -R +x ./matlab-install/
```

## Step 3. Obtain the License File and File Installation Key

1. Log in to your [MathWorks Account](https://www.mathworks.com/login). Select the license you want to use with the container.
1. Select the **Install and Activate** tab.
1. Click “Activate to Retrieve License File” link.
1. Click the download link under **Get License File**.
1. Select the appropriate MATLAB version and click **Continue**.
1. At the prompt “Is the software installed?”, select **No** and click **Continue**.
1. Copy the file installation key into a safe location.

## Step 4. Define Installation Parameters

1. Copy the file `installer_input.txt` from the `alternates/matlab-installer/matlab-install` folder into the `alternates/matlab-installer` folder and rename the file to `matlab_installer_input.txt`. Use this command to copy the folder and rename the file.

```bash
cp ./matlab-install/installer_input.txt ./matlab_installer_input.txt
```

2. Open `matlab_installer_input.txt` in a text editor and edit these sections.
    - `fileInstallationKey` - Paste your File Installation Key and uncomment the line.
    - `agreeToLicense` - Set the value to yes and uncomment the line.
    - Specify products to install. Uncomment the line `product.MATLAB` to install MATLAB. Uncomment the corresponding line for each additional product you want to install. Ensure you are not licensed to use the products, otherwise uncommenting the line will not install the product in the container. Your File Installation Key identifies the products you can install.

## Step 5. Build Image

### MATLAB Release and License Server

The [Dockerfile](https://github.com/mathworks-ref-arch/matlab-dockerfile/blob/main/Dockerfile) supports the following Docker build-time variables:

| Argument Name                                                       | Default Value | Effect                                                                                                                                                |
| ------------------------------------------------------------------- | ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| [MATLAB_RELEASE](#build-an-image-for-a-different-release-of-matlab) | latest        | MATLAB release to install, for example, `R2023b`.                                                                    |
| [LICENSE_SERVER](#build-an-image-with-license-server-information)   | _unset_       | Port and hostname of the machine running the network license manager, using the `port@hostname` syntax. For example: `27000@MyServerName` |

Use these arguments with the `docker build` command to customize your image. Run a command from the `alternates/matlab-installer` of the cloned repository with this form.

```bash
docker build -t matlab:$RELEASE --build-arg MATLAB_RELEASE=$RELEASE --build-arg LICENSE_SERVER=$PORT@$MLM_SERVER .
```

Alternatively, you can change the default values for these arguments directly in the [Dockerfile](https://github.com/mathworks-ref-arch/matlab-dockerfile/blob/main/Dockerfile).

> [!NOTE]
> Use the `LICENSE_SERVER` build argument to generate a valid network license file only if you cannot supply a license file. Omit this argument you have a network license file or no network licensing is required. Modify the commands within the Dockerfile as described within it.

> [!NOTE]
> The build process uses approximately 4GB of RAM, so ensure that the Docker service has sufficient resources.

## Step 6. Run Container

Run the container using a command with this form.

```bash
docker run --init -it --rm matlab:$RELEASE
```

- `-it` option runs the container interactively.
- `--rm` option automatically removes the container on exit.

To change the specified license server at run time, use the `MLM_LICENSE_FILE` environment variable using a command with this form.

```bash
docker run --init -it --rm --env MLM_LICENSE_FILE=$PORT@$MLM_SERVER matlab:$RELEASE
```

If you are not using a license server but instead have a license file, mount it at run time using a command with this form.

```bash
docker run --init -it --rm -v <path/to/licensefile>/license.lic:/license.lic --env MLM_LICENSE_FILE=/license.lic matlab:$RELEASE
```

Insert any extra arguments after the container tag to add as command line arguments to the MATLAB process inside the container. For example, this command prints the version of MATLAB and any toolboxes installed in the container in `-batch` mode.

```bash
docker run --init -it --rm matlab:$RELEASE -batch "ver"
```

## Use a License File to Build Image

If you have a `license.dat` file from your license administrator, use this file to provide the location of the license manager for the container image.

1. Open the `license.dat` file. Copy the `SERVER` line into a new text file.
2. Beneath it, add `USE_SERVER`. The file should now look similar to this.

```
SERVER Server1 0123abcd0123 12345
USE_SERVER
```

3. Save the new text file as `network.lic` in the root folder of the cloned repository.
4. Open the Dockerfile, and comment the line `ENV MLM_LICENSE_FILE`
5. Uncomment the line `COPY network.lic /tmp/network.lic`
6. Run the `docker build` command without the `--build-arg LICENSE_SERVER=$PORT@$MLM_SERVER` option. Use a command with this form.

```bash
docker build -t matlab:<Release> --build-arg MATLAB_RELEASE=$RELEASE
```

For more information about license files, see [What are the differences between the license.lic, license.dat, network.lic, and license_info.xml license files?](https://www.mathworks.com/matlabcentral/answers/116637-what-are-the-differences-between-the-license-lic-license-dat-network-lic-and-license_info-xml-lic)

## More MATLAB Docker Resources

For more information about running MATLAB in a Docker container, see the top level [README](../../README.md#more-matlab-docker-resources) of this repository.

## Help Make MATLAB Even Better

You can help improve MATLAB by providing user experience information on how you use MathWorks products. Your participation ensures that you are represented and helps us design better products. To opt out of this service, delete this line in the Dockerfile.

```Dockerfile
ENV MW_DDUX_FORCE_ENABLE=true MW_CONTEXT_TAGS=MATLAB:MATLAB_INSTALLER:DOCKERFILE:V1
```

To learn more, see the documentation: [Help Make MATLAB Even Better - Frequently Asked Questions](https://www.mathworks.com/support/faq/user_experience_information_faq.html).

## Feedback

We encourage you to try this Dockerfile with your environment and provide feedback. If you encounter a technical issue or have an enhancement request, create an issue [here](https://github.com/mathworks-ref-arch/matlab-dockerfile/issues).

---

Copyright 2023-2024 The MathWorks, Inc.

---
