# MATLAB Package Manager

## Description

MATLAB® Package Manager (**mpm**) is a command-line package manager for MathWorks® products. You can use MATLAB Package Manager to programmatically install MATLAB, Simulink®, and other MathWorks products on Linux® operating systems, or as part of a Dockerfile. MATLAB Package Manager provides options to specify the products, release, and destination for an installation.

## Download MATLAB Package Manager

Use `wget`in your Linux terminal to download the latest version of MATLAB Package Manager.

    wget https://www.mathworks.com/mpm/glnxa64/mpm

Before you run MATLAB Package Manager, give the downloaded file executable permissions.

    chmod +x mpm

`mpm` requires the following packages on your system: `unzip`, `ca-certificates`, and MATLAB Dependencies.

For the MATLAB Dependencies, refer to `base-dependencies.txt` files in the [MATLAB Dependencies](https://github.com/mathworks-ref-arch/container-images/tree/master/matlab-deps) repository corresponding to your MATLAB version and operating system.

## Syntax

- `mpm install --release=<release> --products <product1> ... <productn>` installs products `<product1> ... <productn>` from release version `<release>` to the default installation folder. [Example](#install-matlab-simulink-and-additional-products)

- `mpm install ... <installOptions>` specifies options using one or more installation option flags `<installOptions>` in addition to any of the input argument combinations in the previous syntax. For example, you can specify the install destination, whether to install documentation and examples, and whether to install the GPU libraries for use with Parallel Computing Toolbox™. [Example](#install-matlab-and-specify-installation-options)

- `mpm install-doc --matlabroot <matlabroot>` installs documentation and examples for the MATLAB installation at `<matlabroot>`. [Example](#install-matlab-and-specify-installation-options)

- `mpm install-doc --matlabroot <matlabroot> <docOptions>` installs documentation and examples for the MATLAB installation at `<matlabroot>` and specifies options using one or more documentation installation option flags `<docOptions>`. For example, you can specify the path to a mounted ISO image of the documentation or the documentation installation destination. [Example](#install-matlab-and-specify-installation-options)

- `mpm <globalOption>` specifies a global option `<globalOption>`, ignoring other input arguments. For example, you can show the help or the installed version of MATLAB Package Manager. 

## Examples

### Install MATLAB, Simulink, and Additional Products

To install MATLAB R2023b, Simulink, and Signal Processing Toolbox to the default folder, navigate to the folder containing the `mpm` binary file and run the following command.

    ./mpm install --release=R2023b --products MATLAB Simulink Signal_Processing_Toolbox
    
You can install further products later. For example, add Robotics System Toolbox to the MATLAB installation.

    ./mpm install --release=R2023b --products Robotics_System_Toolbox
 
    
### Install MATLAB and Specify Installation Options

Install MATLAB R2023b, specifying these installation options:

- Set the installation destination folder to `/home/username/matlab`.
- Install Parallel Computing Toolbox without the GPU libraries.

```
./mpm install --release=R2023b --destination=/home/username/matlab --products MATLAB Parallel_Computing_Toolbox --no-gpu  
```

Download a documentation ISO from [Install Documentation on Offline Machines](https://www.mathworks.com/help/install/ug/install-documentation-on-offline-machines.html) and mount the ISO. Install the documentation and examples, specifying the MATLAB installation folder and the path to the mounted ISO.

    ./mpm install-doc --matlabroot=/home/username/matlab --source=/path/to/source

## Global Options
| Option              | Description                                      | Example         |
| ------------------- | ------------------------------------------------ | --------------- |
| `--help` or `-h`    | Flag for showing help.                           | `./mpm --help`    |
| `--version` or `-v` | Flag for showing MATLAB Package Manager version. | `./mpm --version` |

## Installation Options
| Option          | Description                                                                                                                                                                                                                                                                                                                                                                                                                                      | Example                                                      |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------ |
| `--release`     | Software version to install. This option supports releases and updates. To install the latest version of a release, specify the release version (for example, `R2023b`). To install a specific update release, specify the release version with an update number suffix (for example, `R2023bU4`). To install a version without updates, specify the release version with an update 0 or general release suffix (for example, `R2023bU0` or `R2023bGR`). | `R2023b`, `R2023bU2`, `R2023bGR`                              |
| `--products`    | List of products to install, specified as product names separated by spaces. MATLAB Package Manager can install most MathWorks products. For the full list of correctly formatted product names, download the [MathWorks Product Installer](https://www.mathworks.com/help/install/ug/install-noninteractively-silent-installation.html) and refer to the `installer_input.txt` file included in it. Alternatively, see [Products and Services](https://www.mathworks.com/products.html) for product names in the current MATLAB release and replace spaces in names with underscores. For more information on which products MATLAB Package manager can not install, see [Limitations](#limitations).                    | `MATLAB Simulink Deep_Learning_Toolbox Fixed-Point_Designer` |
| `--destination` | Full path to the desired installation folder. Defaults to `/usr/share/matlab` if unset.                                                                                                                                                                                                                                                                                                                                                         | `/path/to/destination`                                       |
| `--source`      | Full path to downloaded product files (optional). MATLAB Package Manager downloads the product files if unset.                                                                                                                                                                                                                                                                                                                                   | `/path/to/source`                                            |
| `--doc`         | Flag to install documentation and examples (optional). Supported for R2022b and earlier releases. To install the documentation in a later release, use the `install-doc` command.                                                                                                                                                                                                                                                                | `--doc`                                                      |
| `--no-gpu`      | Flag to prevent installation of GPU libraries when you install Parallel Computing Toolbox (optional). If you do not intend to use GPU computing in MATLAB, specify this option to reduce the size of the install. You can install the GPU libraries later by calling a GPU function such as `gpuArray` or `gpuDevice` in MATLAB. Supported for releases R2023a and later.                                                                        | `--no-gpu`                                                   |

## Documentation Installation Options

For releases R2023a and later, use the `install-doc` command to install documentation and examples for an existing MATLAB installation.

| Option          | Description                                                                                                                                                                                                                                               | Example               |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `--matlabroot`  | Full path to the folder in which MATLAB is installed.                                                                                                                                                                                                     | `/path/to/matlabroot` |
| `--source`      | Full path to mounted documentation ISO. Defaults to `$PWD/archives` if unset. To download a documentation ISO, see [Install Documentation on Offline Machines](https://www.mathworks.com/help/install/ug/install-documentation-on-offline-machines.html). | `/path/to/source`     |
| `--destination` | Full path to the desired installation folder (optional).                                                                                                                                                                                                  | `/path/to/docroot`    |

## Limitations

- Some MathWorks products are not available on Linux. For a list of products not available on Linux, see [Products Not Available for Linux](https://www.mathworks.com/support/requirements/matlab-linux.html).
- MATLAB Package Manager cannot install the products in the table below.

| Product                 |
| ----------------------- |
| IEC Certification Kit   |
| DO Qualification Kit    |
| Simulink Code Inspector |

- R2017b is the oldest release that MATLAB Package Manager supports.

## Feedback and Support

If you encounter a technical issue or have an enhancement request, create an issue [here](https://github.com/mathworks-ref-arch/matlab-dockerfile/issues).

## Changelog

### 2023.9 - September 13, 2023

- **Fixed:** Resolved an issue that prevented installation of R2023b.

### 2023.3 - March 23, 2023

- **Added:** Specify the `--no-gpu` option to prevent installation of GPU libraries when you install Parallel Computing Toolbox.
- **Changed:** Versioning changed from [Semantic Versioning](https://semver.org/) to [Calendar Versioning](https://calver.org/). 

### 0.8.0 - December 17, 2022

- **Added:** Install a specific MATLAB update level. For example, to download MATLAB R2022b Update 2, specify the `--release` option as `R2022bU2`.

### 0.7.0 - November 4, 2022

- **Added:** Foundation changes to support upcoming features.
- **Fixed:** Improved parsing for `--release` option.

### 0.6.0 - July 14, 2022

- **Added:** By default, MATLAB documentation and examples are not installed with MATLAB.
- **Added:** Use the `--doc` option to include documentation and examples with the MATLAB installation.
- **Added:** The `mpm` command now observes `TMPDIR` environment variable.
- **Fixed:** The `mpm` command no longer crashes at run time on RHEL7/UBI7.
- **Fixed:** Changed dropped packet behavior to improve download resilience in adverse network conditions.
- **Fixed:** Improved error message for installing into a MATLAB instance that does not match the specified release.

### 0.5.1 - February 14, 2022

- **Fixed:** Installing a toolbox into an existing MATLAB instance at any update level that is not the latest update level for that release no longer results in the installed products throwing an error when invoked.

### 0.5.0 - December 6, 2021

- **Added:** Initial release
