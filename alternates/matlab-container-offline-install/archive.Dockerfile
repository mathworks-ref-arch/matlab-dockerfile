# Copyright 2024-2025 The MathWorks, Inc.

# Here is an example docker build command with the optional build arguments.
# docker build --build-arg MATLAB_RELEASE=R2025b
#              --build-arg MATLAB_PRODUCT_LIST="MATLAB Deep_Learning_Toolbox Symbolic_Math_Toolbox"
#              -f archive.Dockerfile
#              -t mpm-archive .

# To specify which MATLAB release to install in the container, edit the value of the MATLAB_RELEASE argument.
# Use uppercase to specify the release, for example: ARG MATLAB_RELEASE=R2021b
ARG MATLAB_RELEASE=R2025b

# Specify the list of products to install into MATLAB.
ARG MATLAB_PRODUCT_LIST="MATLAB"

# The staging location used to store the downloaded mpm archives
ARG MPM_DOWNLOAD_DESTINATION="/usr/local/src"

# Download MPM and installation files in a mathworks/matlab-deps Docker image
# This guarantees that all dependencies are already installed
FROM mathworks/matlab-deps:${MATLAB_RELEASE} AS download

# Declare build arguments to use at the current build stage.
ARG MATLAB_RELEASE
ARG MATLAB_PRODUCT_LIST
ARG MPM_DOWNLOAD_DESTINATION

# Install mpm dependencies.
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install --no-install-recommends --yes \
    wget \
    ca-certificates \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# Run mpm to install MATLAB in the target location.
# If mpm fails to install successfully, then print the logfile in the terminal, otherwise clean up.
RUN wget -q https://www.mathworks.com/mpm/glnxa64/mpm \
    && chmod +x mpm \
    && ./mpm download \
    --release=${MATLAB_RELEASE} \
    --destination=${MPM_DOWNLOAD_DESTINATION} \
    --products ${MATLAB_PRODUCT_LIST} \
    && chmod +x ${MPM_DOWNLOAD_DESTINATION}/mpm/glnxa64/mpm \
    || (echo "MPM Download Failure. See below for more information:" && cat /tmp/mathworks_root.log && false)

# Move MPM and the installation files to a scratch image
FROM scratch

# Declare build arguments to use at the current build stage.
ARG MPM_DOWNLOAD_DESTINATION

COPY --from=download ${MPM_DOWNLOAD_DESTINATION} /
