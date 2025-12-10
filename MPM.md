# MATLAB Package Manager

Use MATLAB® Package Manager (`mpm`) to install MATLAB, Simulink®, and other MathWorks® products or support packages from the operating system command line.

To get `mpm` for Linux, Windows, or macOS, see [Get MATLAB Package Manager](https://www.mathworks.com/help/install/ug/get-mpm-os-command-line.html).

For information on using `mpm`, see these command reference pages:
| Command | Description |
| ------ | ----------- |
[`mpm install`](https://www.mathworks.com/help/install/ug/mpminstall.html) | Install products and support packages
[`mpm download`](https://www.mathworks.com/help/install/ug/mpmdownload.html) | Download products and support packages
[`mpm install-doc`](https://www.mathworks.com/help/install/ug/mpminstalldoc.html) | Install documentation
[`mpm --help`](https://www.mathworks.com/help/install/ug/mpmhelp.html) | Get help using MATLAB Package Manager
[`mpm --version`](https://www.mathworks.com/help/install/ug/mpmversion.html) | Get MATLAB Package Manager version information

For information on using `mpm` in the MATLAB Dockerfile, see [Create a MATLAB Container Image](https://github.com/mathworks-ref-arch/matlab-dockerfile/blob/main/README.md).

## Feedback and Support

If you encounter a technical issue or have an enhancement request, create an issue [here](https://github.com/mathworks-ref-arch/matlab-dockerfile/issues).

## Changelog

### 2025.3 - December 10, 2025
- **Deprecated**: Support for `mpm` on Intel Macs will be removed in a future release. `mpm` will continue to support Apple silicon Macs.

### 2025.2.1 - October 29, 2025
- **Fixed**: Updated Intel Mac `mpm` to include all 2025.2 quality and stability improvements addressed on other platforms. The latest `mpm` release for all platforms is now 2025.2.1.

### 2025.2 - October 15, 2025
- **Fixed**: Addressed issues to improve the quality and stability of `mpm`.
- **Removed**: `mpm` is no longer supported on Red Hat Enterprise Linux 7 (RHEL 7). The last version of `mpm` that supports RHEL 7 is 2025.1. To get earlier versions of `mpm`, [contact support](https://www.mathworks.com/support/contact_us.html).

> **Note:**
> `mpm` was not updated on Intel Macs for 2025.2. When you download the latest version of `mpm` on Intel Macs, you get 2025.1.

### 2025.1 - April 2, 2025
- **Added**: Use the `--no-deps` option of `mpm download` to download only the specified products and omit product dependencies. Specify this option when all required dependencies have already been downloaded or are currently installed.

### 2024.4 - December 11, 2024
- **Added**: Support for installing IEC Certification Kit, DO Qualification Kit, and Simulink Code Inspector from source files downloaded using the interactive product installer, as described in [Download Products Without Installing](https://www.mathworks.com/help/install/ug/download-without-installing.html). You must have a license for these products to download them.
- **Added**: When you download products using `mpm download`, the downloaded folder now includes platform-specific versions of `mpm` that you can use to install products on target computers.

### 2024.3 - October 2, 2024
- **Added**: Use the `--inputfile` option of `mpm download` to download products by specifying options in an input file. Using this file, you can select the products and support packages you want to download without having to enter them at the command line.
- **Added**: Use the `--platforms` option of `mpm download` to download products for multiple platforms. Previously, `mpm download` downloaded products only for the platform of the computer performing the download.

### 2024.2.2 - August 14, 2024
- **Security:** Patched CVE-2023-45853.

### 2024.2.1 - July 24, 2024
- **Fixed:** Resolved an issue that causes `mpm` to fail on some Linux distributions.

### 2024.2 - July 17, 2024
- **Added**: Use `mpm download` to download products and support packages without installing them.
- **Added**: Install support packages that were downloaded using `mpm download`.
- **Added**: Support for installing IEC Certification Kit, DO Qualification Kit, and Simulink Code Inspector from a mounted ISO image. For an example, see [Install Products from Mounted ISO Image](https://www.mathworks.com/help/install/ug/mpminstall.html#mw_3a3793a5-4576-464b-adf9-24c714709e6c).
- **Changed**: `mpm` now omits installing products that are already installed instead of issuing an error.

### 2024.1.1 - March 27, 2024
- **Added:** Specify the `--no-jre` option that allows you to skip installing the default Java Runtime Environment (JRE) used by MATLAB and set a custom JRE instead. For information on which JREs are supported, see [Versions of OpenJDK Compatible with MATLAB by Release](https://www.mathworks.com/support/requirements/openjdk.html) on the MathWorks website.
- **Changed:** Versioning changed from YYYY.MM.MINOR.MICRO to YYYY.MINOR.MICRO [Calendar Versioning](https://calver.org/).

### 2023.12.1 - December 14, 2023
- **Added:** Support for Windows
- **Added:** Support for macOS

### 2023.10.0.1 - October 26, 2023
- **Added:** Install hardware and software support packages.
- **Added:** Install required products automatically. For example, if you specify `--product Simulink`, then `mpm` installs both Simulink and the required product MATLAB.
- **Added:** Install products by specifying options in an input file.

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
