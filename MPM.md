# MATLAB Package Manager

## Description

MATLAB® Package Manager (`mpm`) is a command-line package manager for installing MATLAB, Simulink®, and other MathWorks® products or support packages. You can run the `mpm` command from the operating system command line or from a Dockerfile.

**Supported Platforms**: Linux®

## Download MATLAB Package Manager

From your Linux terminal, use `wget` to download the latest version of `mpm`.

    wget https://www.mathworks.com/mpm/glnxa64/mpm

Give the downloaded file executable permissions so that you can run `mpm`.

    chmod +x mpm

Check that these third-party packages required to run `mpm` are installed on your system.
* `unzip`
* `ca-certificates`

Also check the dependencies required to run MATLAB are installed. To view the list of MATLAB dependencies, from the [MATLAB Dependencies](https://github.com/mathworks-ref-arch/container-images/tree/master/matlab-deps) repository, open the `<release>/<system>/base-dependencies.txt` file, where `<release>` is the MATLAB release you are installing and `<system>` is your operating system.

## Syntax

### Install Products
`mpm install --release=<release> --products <product1> ... <productN>` installs products `<product1> ... <productN>` from release version `<release>` to the default installation folder. [Example](#install-products-to-default-folder)

`mpm install --release=<release> --products <product1> ... <productN> <installOptions>` sets additional [product installation options](#product-installation-options). For example, you can specify the install source or destination, whether to install documentation and examples, and whether to install the GPU libraries for use with Parallel Computing Toolbox™. [Example](#install-products-using-optional-command-line-inputs)

`mpm install --inputfile <fullPathToFile>` install products using the `<fullPathToFile>` input file. You can download a template input file for your desired release from the [mpm-input-files](mpm-input-files) folder. You must specify `--inputfile` without any other options. [Example](#install-products-using-input-file)

#### Product Installation Options
| Option          | Description                                                                                                                                                                                                                                                                                                                                                                                                                                      | Example                                                      |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------ |
| `--release`     | Software version to install. This option supports releases and updates. To install the latest version of a release, specify the release version (for example, `R2023b`). To install a specific update release, specify the release version with an update number suffix (for example, `R2023bU4`). To install a version without updates, specify the release version with an update 0 or general release suffix (for example, `R2023bU0` or `R2023bGR`). | `R2023b`, `R2023bU2`, `R2023bGR`                              |
| `--products`    | List of products to install, specified as product names separated by spaces. `mpm` can install most MathWorks products and support packages. For the full list of correctly formatted product names, download the template input file for your desired release from the [mpm-input-files](mpm-input-files) folder and view the product and support package lists. For more information on which products `mpm` cannot install, see [Limitations](#limitations).                    | `MATLAB Simulink Deep_Learning_Toolbox Fixed-Point_Designer` |
| `--inputfile`   | Full path to the input file used to install products. Download a template input file for your desired release from the [mpm-input-files](mpm-input-files) folder and customize it for your installation. For example, you can specify the products and support packages to install and the desired installation folder. You must specify `--inputfile` without any other options. | `/home/$USER/matlab/mpm_input_r2023b.txt` 
| `--destination` | Full path to the desired installation folder. If you are adding products or support packages to an existing MATLAB installation, specify the full path to where MATLAB is installed. `mpm` determines the folder to which to install support packages based on the MATLAB installation folder. Defaults to `/usr/share/matlab` if unset.                                                                                                                                                                                                                                                                                                                                                         | `/path/to/destination`                                       |
| `--source`      | Full path to downloaded product files (supported since R2018b) or an ISO image (supported since R2021b). `mpm` downloads the product files if unset.                                                                                                                                                                                                                                                                                                                                   | `/path/to/source`                                            |
| `--doc`         | Flag to install documentation and examples (supported for R2022b and earlier). To install the documentation in R2023a and later, use the `install-doc` command.                                                                                                                                                                                                                                                                | `--doc`                                                      |
| `--no-gpu`      | Flag to prevent installation of GPU libraries when you install Parallel Computing Toolbox (supported since R2023a). If you do not intend to use GPU computing in MATLAB, specify this option to reduce the size of the install. You can install the GPU libraries later by calling a GPU function such as `gpuArray` or `gpuDevice` in MATLAB.                                                                        | `--no-gpu`                                                   |

### Install Documentation
*Since R2023a*

`mpm install-doc --matlabroot <matlabroot>` installs documentation and examples for the MATLAB installation at `<matlabroot>`. [Example](#install-products-using-optional-command-line-inputs)

`mpm install-doc --matlabroot <matlabroot> <docOptions>` sets additional [documentation installation options](#documentation-installation-options). For example, you can specify the path to a mounted ISO image of the documentation or the documentation installation destination. [Example](#install-products-using-optional-command-line-inputs)

#### Documentation Installation Options
| Option          | Description                                                                                                                                                                                                                                               | Example               |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `--matlabroot`  | Full path to the folder in which MATLAB is installed.                                                                                                                                                                                                     | `/path/to/matlabroot` |
| `--source`      | Full path to mounted documentation ISO. Defaults to `$PWD/archives` if unset. To download a documentation ISO, see [Install Documentation on Offline Machines](https://www.mathworks.com/help/install/ug/install-documentation-on-offline-machines.html). | `/path/to/source`     |
| `--destination` | Full path to the desired installation folder.                                                                                                                                                                                                  | `/path/to/docroot`    |

### Get Help and Version Information
`mpm --help` or `mpm -h` displays command-line help for `mpm`. Example: `./mpm --help`

`mpm --version` or `mpm -v` displays `mpm` version information. Example: `./mpm --version` 

## Examples

### Install Products to Default Folder

Install MATLAB R2023b, Simulink, and Signal Processing Toolbox™ to the default folder. Navigate to the folder containing the `mpm` binary file and run this command.

    ./mpm install --release=R2023b --products MATLAB Simulink Signal_Processing_Toolbox
    
You can install additional products later. For example, add Robotics System Toolbox™ to the MATLAB installation.

    ./mpm install --release=R2023b --products Robotics_System_Toolbox
 
    
### Install Products Using Optional Command-Line Inputs

Install MATLAB R2023b, specifying these installation options:

- Set the installation destination folder to `/home/$USER/matlab`.
- Install Parallel Computing Toolbox without the GPU libraries.

```
./mpm install --release=R2023b --destination=/home/$USER/matlab --products MATLAB Parallel_Computing_Toolbox --no-gpu  
```

Download a documentation ISO from [Install Documentation on Offline Machines](https://www.mathworks.com/help/install/ug/install-documentation-on-offline-machines.html) and mount the ISO. Install the documentation and examples, specifying the MATLAB installation folder and the path to the mounted ISO.

    ./mpm install-doc --matlabroot=/home/$USER/matlab --source=/path/to/source

### Install Products Using Input File

Install products and support packages for MATLAB R2023b by specifying installation options in a file.

From the [mpm-input-files](mpm-input-files) folder, open the `R2023b` folder and download the `mpm_input_r2023b.txt` input file.

Open the file. Configure the MATLAB installation by uncommenting lines that start with a single `'#'` and updating their values. Update these sections:

*SPECIFY DESTINATION FOLDER*

Uncomment the `destinationFolder` line and set an installation folder. For example:

```
destinationFolder=/home/$USER/matlab
```

*INSTALL PRODUCTS*

Uncomment the `product.MATLAB` and `product.Simulink` lines for installing MATLAB And Simulink.

```
product.MATLAB
# ...
product.Simulink
```

*INSTALL SUPPORT PACKAGES*

Uncomment the `product.Deep_Learning_Toolbox_Model_for_ResNet-50_Network` line to install a Deep Learning Toolbox™ support package. `mpm` will automatically install this support package's required product, Deep Learning Toolbox.
```
product.Deep_Learning_Toolbox_Model_for_ResNet-50_Network
```
Save the file.

Install the products and support package.
```
./mpm install --inputfile /path/to/file/mpm_input_r2023b.txt
```
## Limitations

- `mpm` supports installing products and support packages for these releases only:
  - Products - R2017b or later
  - Support Packages - R2019a or later
- Some MathWorks products are not available on Linux. For the full list, see [Products Not Available for Linux](https://www.mathworks.com/support/requirements/matlab-linux.html).
- `mpm` cannot install these products:

  - IEC Certification Kit
  - DO Qualification Kit
  - Simulink Code Inspector™

  For alternative ways to install these products, see [Install Products](https://www.mathworks.com/help/install/install-products.html).

- `mpm` cannot install these support packages:

  - Image Acquisition Toolbox™ Support Package for GenICam™ Interface
  - Image Acquisition Toolbox Support Package for GigE Vision® Hardware
  - Simulink Coder™ Support Package for BBC micro:bit
  - MATLAB Support Package for IP Cameras
  - New Desktop for MATLAB
  - MATLAB Support Package for Parrot® Drones
  - MATLAB Support Package for Ryze Tello Drones
  - Simulink Real-Time™ Target Support Package

  To install these support packages within MATLAB, see [Get and Manage Add-Ons](https://www.mathworks.com/help/matlab/matlab_env/get-add-ons.html).

## Feedback and Support

If you encounter a technical issue or have an enhancement request, create an issue [here](https://github.com/mathworks-ref-arch/matlab-dockerfile/issues).

## Changelog

### 2023.10.0.1 - October 26, 2023
**Added:** Major new features
  - Install hardware and software support packages.
  - Install required products automatically. For example, if you specify `--product Simulink`, then `mpm` installs both Simulink and the required product MATLAB.
  - Install products by specifying options in an input file.

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
