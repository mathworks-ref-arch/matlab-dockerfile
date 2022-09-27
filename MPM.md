# MATLAB Package Manager

## Description

MATLAB Package Manager (**mpm**) is a command line package manager for MathWorks products. It enables you to install MATLAB, Simulink, and toolboxes programmatically on Linux, or as part of a Dockerfile. mpm provides options to specify the release, destination, products, and toolboxes for the resulting MATLAB installation. By default, mpm does not include MATLAB documentation and examples in the MATLAB installation.

Example usage:

    mpm install --release=R2022b --destination=/home/username/matlab --products MATLAB Simulink Deep_Learning_Toolbox Parallel_Computing_Toolbox

## Download MATLAB Package Manager

To get the latest version of mpm, run the following command in a terminal. You need wget installed.

    wget https://www.mathworks.com/mpm/glnxa64/mpm

Before you run mpm, give the downloaded file executable permissions:

    chmod +x mpm

## Usage

    mpm install --release=<release> --destination=<destination> [--products] <product1> <product2>

### Commands

- help - Show help and exit
- install - Install selected products

### Options

Global options:

    -h [ --help ]         Show help and exit
    -v [ --version ]      Show version and exit

Install options:

    --release arg            The MATLAB release you want you want to install.
    -d [ --destination ] arg Specify the destination path where you want to install MATLAB, for example `/home/username/matlab`.
                             The default path is `/usr/share/matlab`.
    --products arg           Specify the list of products to install using product names separated by spaces. Replace spaces within names with underscores.
                             For example: MATLAB Simulink Deep_Learning_Toolbox Parallel_Computing_Toolbox
    --doc                    Include documentation and examples with the MATLAB installation. By default, mpm omits documentation and examples.

### Example

No documentation and examples:

    mpm install --release=R2022b --destination=/home/username/matlab --products MATLAB Deep_Learning_Toolbox Parallel_Computing_Toolbox

Include documentation and examples:

    mpm install --release=R2022b --destination=/home/username/matlab --doc --products MATLAB Deep_Learning_Toolbox Parallel_Computing_Toolbox

## Product Availability

**mpm** can install most MathWorks products. [See the MathWorks website](https://www.mathworks.com/products.html) for the full list of available products and their names. Replace spaces with underscores when specifying product names with the `--products` option."

**mpm** can only install products that are available for Linux. For limitations see [Products Not Available for Linux.](https://www.mathworks.com/support/requirements/matlab-system-requirements.html?sec=linux)

**R2017b** is the oldest release supported by **mpm**.

## Feedback and Support

Go to https://www.mathworks.com/support.html and select Installation help.

## Changelog

### 0.6.0 - July 14, 2022

- **Added:** By default, MATLAB documentation and examples are not installed with MATLAB
- **Added:** --doc option. Includes documentation and examples with the MATLAB installation
- **Added:** mpm now observes TMPDIR environment variable
- **Fixed:** mpm no longer crashes at runtime on RHEL7/UBI7
- **Fixed:** Changed dropped packet behavior, improving download resilience in adverse network conditions
- **Fixed:** Improved error message for installing into a MATLAB instance that does not match the specified release

### 0.5.1 - February 14, 2022

- **Fixed:** Installing a toolbox into an existing MATLAB instance at any update level that isn't the latest update level for that release would result in the installed toolbox(es) throwing an error when invoked.

### 0.5.0 - December 6, 2021

- **Added:** ​​​​​​​Initial release
