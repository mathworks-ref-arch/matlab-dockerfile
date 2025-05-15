# Copyright 2023-2025 The MathWorks, Inc.

# To specify which MATLAB release you wish to install in the container, edit the value of the MATLAB_RELEASE argument.
# Use lower case to specify the release.
ARG MATLAB_RELEASE=r2025a

FROM ubuntu as versioner

ARG MATLAB_RELEASE

COPY matlab-install/VersionInfo.xml /VersionInfo.xml

RUN RELEASE=`sed -ne "s/.*<release>\(.*\)<\/release>.*/\L\1/p" /VersionInfo.xml` \
    && if [ "$MATLAB_RELEASE" != "$RELEASE" ]; then echo "Provided release (${MATLAB_RELEASE}) does not match release found in VersionInfo.xml ($RELEASE)"; exit 1; fi

# When you start the build stage, this Dockerfile uses the mathworks/matlab-deps image related to the chosen release.
# This base image contains the required dependencies of the chosen MATLAB release.
# To check the available mathworks/matlab-deps images, see: https://hub.docker.com/r/mathworks/matlab.
FROM mathworks/matlab-deps:${MATLAB_RELEASE} as base

# Switch to root's home directory to avoid polluting the / directory.
WORKDIR /root

# Install MATLAB in a multi-build style.
FROM base as middle-stage

######
# Create a self-contained MATLAB installer using these instructions:
#
# https://www.mathworks.com/help/install/ug/download-only.html
#
# You must be an administrator on your license to complete this workflow.
# You can run the installer on any platform to create a self-contained MATLAB installer.
# When creating the installer, on the "Folder and Platform Selection" screen, select "Linux (64-bit)".
#
# Put the installer in a directory called matlab-install.
# Move that matlab-install folder to be in the same folder as this Dockerfile.
######

# Add the extracted MATLAB installer to the image
COPY matlab-install /matlab-install/

# Copy the file matlab-install/installer_input.txt into the same folder as the
# Dockerfile and edit this file to specify the products that you want to install.
# Note that you must change the following set of parameters in the file:
#   fileInstallationKey
#   agreeToLicense=yes
#   Uncomment products you want to install
COPY matlab_installer_input.txt /matlab_installer_input.txt

# For installs prior to R2020a, uncomment one of the following 2 ways of adding the license file.
# If you use a release of MATLAB after, and including, R2020a both methods can be commented out.
# If this is done, either mount a license file or specify a license server at runtime.
# You must also comment out the commands directly after the install relating to the license file.

# The first way to add a license file is to use the LICENSE_SERVER argument to automatically
# generate a valid network.lic file.
# Print this file out to verify that it has been generated successfully.
ARG LICENSE_SERVER
RUN SERVER=$(echo ${LICENSE_SERVER} | sed 's/.*@//') \
    && PORT=$(echo ${LICENSE_SERVER} | sed 's/@.*//') \
    && printf "SERVER ${SERVER} ${PORT}\nUSE_SERVER\n" > /tmp/network.lic \
    && cat /tmp/network.lic

# Alternatively you can supply a network license file directly into the container.
# Fill this file with the details of the license server you want to use and uncomment the following line.
# COPY network.lic /tmp/network.lic

# The following commands are used to set installation information specific to the installation of MATLAB
# within the docker image.
# This replaces the command line flags as not all versions support them.
RUN sed -i 's/# destinationFolder=$/destinationFolder=\/usr\/local\/MATLAB/' /matlab_installer_input.txt \
    && sed -i 's/# licensePath=$/licensePath=\/tmp\/network.lic/' /matlab_installer_input.txt \
    && sed -i 's/# outputFile=$/outputFile=\/tmp\/install.log/' /matlab_installer_input.txt

# Now install MATLAB
RUN cd /matlab-install \
    && chmod +x ./install \
    && ./install \
    -mode silent \
    -inputFile /matlab_installer_input.txt \
    && if ! [ -f /usr/local/MATLAB/bin/matlab ]; then \
        cat /tmp/install.log \
        && echo "Installation failed and MATLAB was not installed. See the build log above for more information"; \
    exit 1; fi

# If you did not specify a license server at build, comment these lines.
RUN mkdir -p /usr/local/MATLAB/licenses \
    && cp /tmp/network.lic /usr/local/MATLAB/licenses/

# Build final container image.
FROM base

COPY --from=middle-stage /usr/local/MATLAB /usr/local/MATLAB

# Soft link MATLAB into /usr/local/bin.
RUN ln -s /usr/local/MATLAB/bin/matlab /usr/local/bin/matlab

# Add a user other than root to run MATLAB.
RUN useradd -ms /bin/bash matlab

# Add give that user sudo privileges.
RUN echo "matlab ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/matlab \
    && chmod 0440 /etc/sudoers.d/matlab

# Finally clean up after apt-get.
RUN apt-get clean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

# The following environment variables allow MathWorks to understand how this MathWorks
# product (MATLAB Dockerfile) is being used. This information helps us make MATLAB even better.
# Your content, and information about the content within your files, is not shared with MathWorks.
# To opt out of this service, delete the environment variables defined in the following line.
# See the Help Make MATLAB Even Better section in the accompanying README to learn more:
# https://github.com/mathworks-ref-arch/matlab-dockerfile#help-make-matlab-even-better
ENV MW_DDUX_FORCE_ENABLE=true MW_CONTEXT_TAGS=MATLAB:MATLAB_INSTALLER:DOCKERFILE:V1

# Set user and work directory.
USER matlab
WORKDIR /home/matlab
ENTRYPOINT ["matlab"]
CMD [""]
