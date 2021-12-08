# MATLAB Package Manager

## Description
MATLAB Package Manager (**mpm**) is a command line package manager for MathWorks products. It enables you to install MATLAB and its toolboxes programmatically on a Linux environment. It provides options to specify the release of MATLAB that you want to install and the destination for installation. You can install MATLAB and any specified combination of MATLAB toolboxes. You can use **mpm** to build MATLAB Docker containers.

Example usage:

    mpm install --release=R2021b --destination=/home/username/matlab MATLAB Simulink Deep_Learning_Toolbox Parallel_Computing_Toolbox

## Download MATLAB Package Manager
You must use the latest version of **mpm**. To get the latest version of **mpm**, run the following command in a terminal. You need wget installed.

    wget https://www.mathworks.com/mpm/glnxa64/mpm

Before you can run **mpm**, you need to give the downloaded file executable permissions, as follows:

    chmod +x mpm

## Usage

    mpm install --release=<release> --destination=<destination> [--products] <product1> <product2>

### Commands

* help         - Show help and exit
* install      - Install selected products

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

### Example

    mpm install --release=R2021b --destination=/home/username/matlab MATLAB Deep_Learning_Toolbox Parallel_Computing_Toolbox

## Product Availability

**mpm** can install most MathWorks products. [See the MathWorks website](https://www.mathworks.com/products.html) for the full list of available products and their names. Replace spaces with underscores when specifying product names for the `--products` arg.

**mpm** can only install products that are available for Linux. For limitations see [Products Not Available for Linux.](https://www.mathworks.com/support/requirements/matlab-system-requirements.html?sec=linux)

**R2017b** is the oldest release supported by **mpm**.

## Feedback and Support

Go to https://www.mathworks.com/support.html and select "Installation help".
