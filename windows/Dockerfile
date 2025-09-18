# Copyright 2025 The MathWorks, Inc.
# This Dockerfile allows you to build a Windows® Docker® image with MATLAB® using the MATLAB Package Manager.
# You can then use a MATLAB batch licensing token to license MATLAB in the container. Use the optional build arguments to
# customize the version of MATLAB, and the list of products to install.

# Here is an example docker build command with the optional build arguments.
# docker build --build-arg MATLAB_RELEASE=R2025b
#              --build-arg MATLAB_PRODUCT_LIST="MATLAB Deep_Learning_Toolbox Symbolic_Math_Toolbox"
#              -t my_matlab_image_name .

# To specify which MATLAB release to install in the container, edit the value of the MATLAB_RELEASE argument.
# Use uppercase to specify the release, for example: ARG MATLAB_RELEASE=R2021b
ARG MATLAB_RELEASE="R2025b"

# Specify the list of products to install into MATLAB.
ARG MATLAB_PRODUCT_LIST="MATLAB"

# This Dockerfile uses the Windows base image which contains the full Windows API set. For details, see https://hub.docker.com/r/microsoft/windows
FROM mcr.microsoft.com/windows:ltsc2019

ARG MATLAB_RELEASE
ARG MATLAB_PRODUCT_LIST

# Set the shell to be powershell, and stop on errors
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue'; $verbosePreference='Continue';"]

# Run mpm to install MATLAB in the target location and delete the mpm installation afterwards.
# If mpm fails to install successfully, then print the logfile in the terminal, otherwise clean up.
RUN Invoke-WebRequest -OutFile "$Env:TEMP\mpm.exe" -Uri "https://www.mathworks.com/mpm/win64/mpm" ; \
    $PRODUCT_LIST = -split $Env:MATLAB_PRODUCT_LIST ; \
    & "$Env:TEMP\mpm.exe" install --release $Env:MATLAB_RELEASE --destination "C:\MATLAB" $PRODUCT_LIST ; \
    if ($LASTEXITCODE -ne 0) { \
        Get-Content "$Env:TEMP\mathworks_$Env:USERNAME.log"; throw \
    } else { \
        Remove-Item "$Env:TEMP\mpm.exe" ; Remove-Item "$Env:TEMP\mathworks_$Env:USERNAME.log" \
    }

# Install matlab-batch to enable the use of MATLAB batch licensing tokens.
RUN Set-ExecutionPolicy RemoteSigned -Scope Process ; \
    Invoke-WebRequest -OutFile $Env:TEMP\install-matlab-batch.ps1 -Uri  "https://raw.githubusercontent.com/mathworks-ref-arch/matlab-dockerfile/main/alternates/non-interactive/install/install-matlab-batch.ps1" ; \
     & $Env:TEMP\install-matlab-batch.ps1 ; \
     Remove-Item $Env:TEMP\install-matlab-batch.ps1

# The following environment variables allow MathWorks to understand how this MathWorks
# product (MATLAB On Windows Dockerfile) is being used. This information helps us make MATLAB even better.
# Your content, and information about the content within your files, is not shared with MathWorks.
# To opt out of this service, delete the environment variables defined in the following line.
# To learn more, see the Help Make MATLAB Even Better section in the accompanying README:
# https://github.com/mathworks-ref-arch/matlab-dockerfile#help-make-matlab-even-better
ENV MW_DDUX_FORCE_ENABLE=true MW_CONTEXT_TAGS=MATLAB:WINDOWSNONINTERACTIVE:DOCKERFILE:V1

# Set the entrypoint
ENTRYPOINT ["powershell.exe"]
