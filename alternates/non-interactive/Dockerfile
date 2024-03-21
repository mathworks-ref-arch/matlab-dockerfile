# Copyright 2024 The MathWorks, Inc.
# This Dockerfile allows you to build a Docker® image with MATLAB® installed using the MATLAB Package
# Manager and licensed using MATLAB Batch Licensing. Use the optional build arguments to customize the
# version of MATLAB, list of products to install, and the location at which to install MATLAB.

# Here is an example docker build command with the optional build arguments.
# docker build --build-arg MATLAB_RELEASE=r2024a
#              --build-arg MATLAB_PRODUCT_LIST="MATLAB Deep_Learning_Toolbox Symbolic_Math_Toolbox"
#              --build-arg MATLAB_INSTALL_LOCATION="/opt/matlab/R2024a"
#              -t my_matlab_image_name .

# To specify which MATLAB release to install in the container, edit the value of the MATLAB_RELEASE argument.
# Use lowercase to specify the release, for example: ARG MATLAB_RELEASE=r2021b
ARG MATLAB_RELEASE=r2024a

# Specify the list of products to install into MATLAB.
ARG MATLAB_PRODUCT_LIST="MATLAB"

# Specify MATLAB Install Location.
ARG MATLAB_INSTALL_LOCATION="/opt/matlab/${MATLAB_RELEASE}"

# When you start the build stage, this Dockerfile by default uses the Ubuntu-based matlab-deps image.
# To check the available matlab-deps images, see: https://hub.docker.com/r/mathworks/matlab-deps
FROM mathworks/matlab-deps:${MATLAB_RELEASE}

# Declare build arguments to use at the current build stage.
ARG MATLAB_RELEASE
ARG MATLAB_PRODUCT_LIST
ARG MATLAB_INSTALL_LOCATION

# Install mpm dependencies.
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install --no-install-recommends --yes \
    wget \
    unzip \
    ca-certificates \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# Add "matlab" user and grant sudo permission.
RUN adduser --shell /bin/bash --disabled-password --gecos "" matlab \
    && echo "matlab ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/matlab \
    && chmod 0440 /etc/sudoers.d/matlab

# Set user and work directory.
USER matlab
WORKDIR /home/matlab

# Run mpm to install MATLAB in the target location and delete the mpm installation afterwards.
# If mpm fails to install successfully, then print the logfile in the terminal, otherwise clean up.
# Pass in $HOME variable to install support packages into the user's HOME folder.
RUN wget -q https://www.mathworks.com/mpm/glnxa64/mpm \ 
    && chmod +x mpm \
    && sudo HOME=${HOME} ./mpm install \
    --release=${MATLAB_RELEASE} \
    --destination=${MATLAB_INSTALL_LOCATION} \
    --products ${MATLAB_PRODUCT_LIST} \
    || (echo "MPM Installation Failure. See below for more information:" && cat /tmp/mathworks_root.log && false) \
    && sudo rm -rf mpm /tmp/mathworks_root.log ${HOME}/.MathWorks \
    && sudo ln -s ${MATLAB_INSTALL_LOCATION}/bin/matlab /usr/local/bin/matlab

# Install matlab-batch to enable the use of MATLAB batch licensing tokens.
RUN wget -q https://ssd.mathworks.com/supportfiles/ci/matlab-batch/v1/glnxa64/matlab-batch \
    && sudo mv matlab-batch /usr/local/bin \
    && sudo chmod +x /usr/local/bin/matlab-batch

# The following environment variables allow MathWorks to understand how this MathWorks
# product (MATLAB Non-Interactive Dockerfile) is being used. This information helps us make MATLAB even better.
# Your content, and information about the content within your files, is not shared with MathWorks.
# To opt out of this service, delete the environment variables defined in the following line.
# To learn more, see the Help Make MATLAB Even Better section in the accompanying README:
# https://github.com/mathworks-ref-arch/matlab-dockerfile#help-make-matlab-even-better
ENV MW_DDUX_FORCE_ENABLE=true MW_CONTEXT_TAGS=MATLAB:BATCHLICENSING:DOCKERFILE:V1
