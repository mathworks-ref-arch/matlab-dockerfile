# MATLAB Batch Licensing Executable

MATLAB&reg; batch licensing executable (**matlab-batch**) is a command line tool that starts MATLAB non-interactively using a batch licensing token and any MATLAB startup options. Specify a MATLAB statement to run as the final argument. **matlab-batch** requires a valid MATLAB executable.

The MATLAB batch licensing project is still in the pilot phase. To inquire about eligibility requirements, fill out this form on the MathWorks&reg; website: [Batch Licensing Pilot Eligibility](https://www.mathworks.com/support/batch-tokens.html).


## Install MATLAB Batch Licensing Executable

You can install the MATLAB batch licensing executable either by using the installer script or by downloading it and setting it up manually. 

The installer script sets up the MATLAB Batch Licensing Executable in a default location and adds it to your system path for easy command line access. It also allows you to install the executable in a preferred location. 

### Install MATLAB Batch Licensing Executable Using the Installer Script

On macOS, Linux&reg;, and emulated Linux environments (Cygwin&trade;, MinGW&reg;, MSYS2) on Windows&reg;, use the following commands to install `matlab-batch`:
```bash
curl -s 'https://raw.githubusercontent.com/mathworks-ref-arch/matlab-dockerfile/main/alternates/non-interactive/install/install-matlab-batch.sh' -o 'install-matlab-batch.sh'
sudo bash ./install-matlab-batch.sh 
```

To install it in a custom location, such as `/opt/my-custom-installs/`, use this command:
```bash
sudo bash ./install-matlab-batch.sh -i '/opt/my-custom-location'
```
> Note: the -i option accepts both absolute and relative paths.

On Windows, use the following commands to install `matlab-batch` in a PowerShell session with elevated permissions (you must start PowerShell with the "Run as Administrator" option):
```powershell
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/mathworks-ref-arch/matlab-dockerfile/main/alternates/non-interactive/install/install-matlab-batch.ps1' -OutFile 'install-matlab-batch.ps1'
.\install-matlab-batch.ps1
```

To install it in a custom location, such as `C:\Program Files\my-custom-location`, use this command: 
```powershell
.\install-matlab-batch.ps1 -InstallLocation 'C:\Program Files\my-custom-location'
```

> Note: the -InstallLocation option accepts both absolute and relative paths.

### Download MATLAB Batch Licensing Executable and Install Manually

#### Linux

From a Linux terminal, use `wget` to download the latest version of `matlab-batch`.

    wget https://ssd.mathworks.com/supportfiles/ci/matlab-batch/v1/glnxa64/matlab-batch

Grant the downloaded file executable permissions so that you can run `matlab-batch`.

    chmod +x matlab-batch

#### Windows

From a Windows PowerShell command prompt, use `Invoke-WebRequest` to download the latest version of `matlab-batch`.

    Invoke-WebRequest https://ssd.mathworks.com/supportfiles/ci/matlab-batch/v1/win64/matlab-batch.exe -OutFile matlab-batch.exe

#### macOS

From a macOS terminal, use `curl` to download the latest version of `matlab-batch` for your macOS architecture.

* macOS (Intel processor)

      curl -L -o ~/Downloads/matlab-batch https://ssd.mathworks.com/supportfiles/ci/matlab-batch/v1/maci64/matlab-batch

* macOS (Apple silicon processor)

      curl -L -o ~/Downloads/matlab-batch https://ssd.mathworks.com/supportfiles/ci/matlab-batch/v1/maca64/matlab-batch

`matlab-batch` is downloaded to your `Downloads` folder. Navigate to that folder.

    cd ~/Downloads

Give the downloaded file executable permissions so that you can run `matlab-batch`.

    chmod +x matlab-batch

## Syntax

- `matlab-batch -licenseToken <token> <statement>` starts MATLAB using the batch licensing token `<token>` and then runs the MATLAB statement `<statement>`. You can omit the `-licenseToken` argument if you specify the batch licensing token in the `MLM_LICENSE_TOKEN` environment variable. [Example](#hello-world)

- `matlab-batch -licenseToken <token> <option1> ... <optionN> <statement>` specifies MATLAB start-up options using one or more option flags `<optionX>`. [Example](#run-matlab-with-startup-options)

- `matlab-batch <globalOption>` specifies a global option `<globalOption>`, ignoring other input arguments. For example, you can show the help or the installed version of **matlab-batch**.

> **Note: Selecting the MATLAB executable to start**
>
>  If the **matlab-batch** executable is in a folder containing a **matlab** (case-sensitive) executable, it starts that MATLAB.
> Otherwise, it starts the first MATLAB on your PATH environment variable.

## Examples

### Hello, World.
To execute a MATLAB statement, navigate to the folder containing the `matlab-batch` binary file and run the following command.

    ./matlab-batch -licenseToken "user@email.com|encodedToken" "disp('Hello, World.')"

You can also provide your MATLAB batch licensing token with the `MLM_LICENSE_TOKEN` environment variable.

    export MLM_LICENSE_TOKEN="user@email.com|encodedToken"
    ./matlab-batch "disp('Hello, World.')"

### Run MATLAB with Startup Options
To run MATLAB with any set of arguments, such as `-logfile`, execute:

    ./matlab-batch -licenseToken "user@email.com|encodedToken" -logfile "logfilename.log" "myscript"

To learn more, see the documentation: [Commonly Used Startup Options](https://www.mathworks.com/help/matlab/matlab_env/commonly-used-startup-options.html).

## Global Options
| Option                        | Description                                         | Example                                    |
| ----------------------------- | --------------------------------------------------- | ------------------------------------------ |
| `-help` or `-h`               | Flag for showing help.                              | `matlab-batch -help`                       |
| `-version` or `-v`            | Flag for showing **matlab-batch** version.          | `matlab-batch -version`                    |
| `-displayLicenseAgreement`    | Flag for showing the software license.              | `matlab-batch -displayLicenseAgreement`    |
| `-display3pLicenseAgreements` | Flag for showing the third-party software licenses. | `matlab-batch -display3pLicenseAgreements` |

## Batch Options
| Option          | Description | Example |
| --------------- | ----------- | ------- |
| `-licenseToken` | MATLAB batch licensing token. Related environment variable: `MLM_LICENSE_TOKEN`. | `user@email.com\|label\|encodedToken`, `user@email.com\|encodedToken` |

## MATLAB Batch Licensing Token

MATLAB batch licensing tokens are strings that enable MATLAB to start in non-interactive environments. A token is a unique identifier that grants access to your MATLAB products.

MATLAB batch licensing tokens come in two formats:
 - `user@email.com|encodedToken`
 - `user@email.com|label|encodedToken`

These tokens can be used instead of, or in addition to, other types of licensing.

If your batch licensing token expires in less than 30 days, **matlab-batch** prints a warning message. To suppress this message, you can set the environment variable MW_DISABLE_TOKEN_EXPIRY_WARNING to 1.

## Limitations

 - R2020b is the oldest release that **matlab-batch** supports on Linux and macOS with Intel&reg;.
 - R2021a is the oldest release that **matlab-batch** supports on Windows.
 - R2023b is the oldest release that **matlab-batch** supports on macOS with Apple silicon.

## Feedback and Support
To inquire about eligibility requirements for the MATLAB batch licensing pilot, fill out this form on the MathWorks website: [Batch Licensing Pilot Eligibility](https://www.mathworks.com/support/batch-tokens.html).

For support, contact [MathWorks Technical Support](https://www.mathworks.com/support/contact_us.html).

## Changelog

### v2024.10.0
- **Fixed:** Robustness of error reporting.

### v2024.09.0
- **Fixed:** Error reporting related to MATLAB shutdown.
 
### v2024.07.0
- **Added:** Internal changes to support upcoming features.

### v2024.06.1
- **Added:** Support for MATLAB R2024b.

### v2024.06.0
- **Fixed:** Error message on finding an unsupported old MATLAB release.
- **Added:** Warning messages when **matlab-batch** will soon expire.

### v2024.05.0

- **Added:** Notification when **matlab-batch** requires redownloading.
- **Added:** Trimming of whitespace from front and back of tokens.
- **Fixed:** Robustness against poor network conditions.

### v2024.02.1

- **Added:** Support for macOS with Apple silicon.

### v2024.02.0

- **Added:** Support for MATLAB R2024b.
- **Added:** Notifications when tokens are close to expiring.
- **Added:** File details (including application version) integrated with Windows Explorer.
- **Fixed:** **matlab-batch** supports Parallel Computing workflows.
- **Fixed:** Improved ability to detect valid MATLAB installations.

### v2023.10.1

- **Added:** Support for MATLAB R2023b.

### v2023.10.0

- **Added:** Initial release.
- **Added:** Support for MATLAB R2020b to R2023a.

---
Copyright 2024 The MathWorks, Inc.
