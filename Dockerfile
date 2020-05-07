# Copyright 2019 - 2020 The MathWorks, Inc.

FROM ubuntu:18.04 as prebuilder

LABEL  MAINTAINER=MathWorks

#### Get Dependencies ####

RUN apt-get update && apt-get install --no-install-recommends -y \
        ca-certificates \
        libasound2 \
        libatk1.0-0 \
        libavcodec-extra57 \
        libavformat57 \
        libc6 \
        libcairo-gobject2 \
        libcairo2 \
        libcups2 \
        libdbus-1-3 \
        libfontconfig1 \
        libgdk-pixbuf2.0-0 \
        libgstreamer-plugins-base1.0-0 \
        libgstreamer1.0-0 \
        libgtk-3-0 \
        libnspr4 \
        libnss3 \
        libpam0g \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libpangoft2-1.0-0 \
        libpython2.7 \
        libpython3.6 \
        libpython3.7 \
        libselinux1 \
        libsm6 \
        libsndfile1 \
        libx11-6 \
        libx11-xcb1 \
        libxcb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxft2 \
        libxi6 \
        libxinerama1 \
        libxrandr2 \
        libxrender1 \
        libxt6 \
        libxtst6 \
        libxxf86vm1 \
        locales \
        locales-all \
        procps \
        sudo \
        xkb-data \
        zlib1g \
    && apt-get clean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

# Uncomment the following RUN ln -s statement if you will be running the MATLAB 
# license manager INSIDE the container.
#RUN ln -s ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3

# Uncomment the following RUN apt-get statement if you will be using Simulink 
# code generation capabilities, or if you will be compiling your own mex files
# with gcc, g++, or gfortran.
#
#RUN apt-get install -y gcc g++ gfortran

# Uncomment the following RUN apt-get statement to enable running a program
# that makes use of MATLAB's Engine API for C and Fortran
# https://www.mathworks.com/help/matlab/matlab_external/introducing-matlab-engine.html
#
#RUN apt-get install -y csh

# Uncomment ALL of the following RUN apt-get statement to enable the playing of media files
# (mp3, mp4, etc.) from within MATLAB.
#
#RUN apt-get install --no-install-recommends -y libgstreamer1.0-0 \
# gstreamer1.0-tools \
# gstreamer1.0-libav \
# gstreamer1.0-plugins-base \
# gstreamer1.0-plugins-good \
# gstreamer1.0-plugins-bad \
# gstreamer1.0-plugins-ugly

# Uncomment the following line if you require the fuse filesystem - but note that
# to use fuse in a container you will also need to start the container with the following
# options (depending on your system configuration)
#   –device /dev/fuse --cap-add SYS_ADMIN
#RUN apt-get install --no-install-recommends -y libfuse2

# Uncomment the following line if you require network tools
#RUN apt-get install --no-install-recommends -y net-tools

# Uncomment the following RUN apt-get statement if you will be using the 32-bit tcc compiler
# used in the Polyspace product line.
#RUN apt-get install -y libc6-i386

# To avoid inadvertantly polluting the / directory, use root's home directory 
# while running MATLAB.
WORKDIR /root

#### Install MATLAB in a multi-build style ####
FROM prebuilder as middle-stage

######
# Create a self-contained MATLAB installer using these instructions:
#
# https://www.mathworks.com/help/install/ug/download-only.html
#
# You must be an administrator on your license to complete this workflow
# You can run the installer on any platform to create a self-contained MATLAB installer
# When creating the installer, on the "Folder and Platform Selection" screen, select "Linux (64-bit)"
#
# Put the installer in a directory called matlab-install
# Move that matlab-install folder to be in the same folder as this Dockerfile
######

# Add MATLAB installer to the image
ADD matlab-install /matlab-install/

# Copy the file matlab-install/installer_input.txt into the same folder as the 
# Dockerfile. The edit this file to specify what you want to install. NOTE that 
# at a minimum you will need to have changed the following set of parameters in 
# the file.
#   fileInstallationKey
#   agreeToLicense=yes
#   Uncommented products you want to install
ADD matlab_installer_input.txt /matlab_installer_input.txt

# Alternatively you can put a license file (or license information) into the 
# container. You should fill this file out with the details of the license 
# server you want to use nd uncomment the following line.
# ADD network.lic /usr/local/MATLAB/licenses/

# Now install MATLAB (make sure that the install script is executable)
RUN cd /matlab-install && \
    chmod +x ./install && \
    ./install -mode silent \
        -inputFile /matlab_installer_input.txt \
        -outputFile /tmp/mlinstall.log \
        -destinationFolder /usr/local/MATLAB \
    ; EXIT=$? && cat /tmp/mlinstall.log && test $EXIT -eq 0


#### Build final container image ####
FROM prebuilder

COPY --from=middle-stage /usr/local/MATLAB /usr/local/MATLAB

# Add a script to start MATLAB and soft link into /usr/local/bin
ADD startmatlab.sh /opt/startscript/
RUN chmod +x /opt/startscript/startmatlab.sh && \
    ln -s /usr/local/MATLAB/bin/matlab /usr/local/bin/matlab

# Add a user other than root to run MATLAB
RUN useradd -ms /bin/bash matlab
# Add bless that user with sudo powers
RUN echo "matlab ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/matlab \
    && chmod 0440 /etc/sudoers.d/matlab

# One of the following 2 ways of configuring the FlexLM server to use must be
# uncommented.

ARG LICENSE_SERVER
# Specify the host and port of the machine that serves the network licenses 
# if you want to bind in the license info as an environment variable. This 
# is the preferred option for licensing. It is either possible to build with 
# something like --build-arg LICENSE_SERVER=27000@MyServerName, alternatively
# you could specify the licens server directly using
#       ENV MLM_LICENSE_FILE=27000@flexlm-server-name
ENV MLM_LICENSE_FILE=$LICENSE_SERVER
   
USER matlab
WORKDIR /home/matlab

# Uncomment and maybe change the following line to setup mex in your container
# RUN /usr/local/MATLAB/bin/mex -v -setup C++


ENTRYPOINT ["/opt/startscript/startmatlab.sh"]
