
# Copyright 2019 The MathWorks, Inc.

FROM debian:stretch as prebuilder

#MAR - MAINTAINER keyword is deprecated, creating a label is now favored.
#      Keeping the previous setup, however, we should probably make this OCI compliant.
LABEL  MAINTAINER=MathWorks
 
#### Get Dependencies ####
# MAR - Changed lsb-release to lsb - wasnt working otherwise - need to understand why.
# MAR - Added dos2unix so that it can be run on the startscript...
#       better than relying on the user to make sure the line endings are correct, especially
#       if the image is being built on a Windows OS.
# MAR - Updated the list to also be alpha-order per dockerfile best practice.  Found
#       a dupe of xvfb in the process.
# MAR - Would also be useful to validate the list, as the container size gets quite 
#       large with all of these dependencies, and I'm not sure they are all needed.
#       Is there perhaps a doc page that enumerates these resources?

RUN apt-get update && apt-get install -y \
ca-certificates \
dos2unix \
libasound2 \
libatk1.0-0 \
libc6 \
libcairo2 \
libcap2 \
libcomerr2 \
libcups2 \
libdbus-1-3 \
libfontconfig1 \
libgconf-2-4 \
libgcrypt20 \
libgdk-pixbuf2.0-0 \
libgssapi-krb5-2 \
libgstreamer-plugins-base1.0-0 \
libgstreamer1.0-0 \
libgtk2.0-0 \
libk5crypto3 \
libkrb5-3 \
libnspr4 \
libnspr4-dbg \
libnss3 \
libpam0g \
libpango-1.0-0 \
libpangocairo-1.0-0 \
libpangoft2-1.0-0 \
libselinux1 \
libsm6 \
libsndfile1 \
libudev1 \
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
libxmu6 \
libxrandr2 \
libxrender1 \
libxslt1.1 \
libxss1 \
libxt6 \
libxtst6 \
libxxf86vm1 \
lsb \
procps \
sudo \
x11vnc \
xkb-data \
xvfb \
zlib1g

# Uncomment the following RUN apt-get statement to install extended locale support for MATLAB
#RUN apt-get install -y locales locales-all

# Uncomment the following RUN ln -s statement if you will be running the MATLAB 
# license manager INSIDE the container.
#RUN ln -s ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3

# Uncomment the following RUN apt-get statement if you will be using Simulink 
# code generation capabilities, or if you will be using mex with gcc, g++, 
# or gfortran.
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
#RUN apt-get install -y libgstreamer1.0-0 \
# gstreamer1.0-tools \
# gstreamer1.0-libav \
# gstreamer1.0-plugins-base \
# gstreamer1.0-plugins-good \
# gstreamer1.0-plugins-bad \
# gstreamer1.0-plugins-ugly \
# gstreamer1.0-doc

# Uncomment the following RUN apt-get statement if you will be using the 32-bit tcc compiler
# used in the Polyspace product line.
#
# MAR - Not actually sure this is needed for Polyspace... but uncommenting it for now since I
#       am focused on a PS Server + Matlab container here.
RUN apt-get install -y libc6-i386

# To avoid inadvertantly polluting the / directory, use root's home directory 
# while running MATLAB.
WORKDIR /root

#### Install MATLAB in a multi-build style ####
## The middle-stage-common used for the common installer
## The build stage WILL run out of space if matlab and polyspace
## installs run back to back in the same stage.
FROM prebuilder as middle-stage-common

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
COPY matlab-install /matlab-install/
#MAR - Discovered that when using a network license, silent mode requires the license to be used
#      in the installer_input.txt instructions... So need a copy for the install run.
COPY network.lic /network.lic

# MAR -  In case building this on windows, need to chmod -R a+x the directory or the install won't work...
RUN chmod -R a+x /matlab-install

# MAR - Moved the following to be for both middle stages, but modified to handle the need for a separate
#       install of Polyspace, until the install team allows a multi-license install so Polyspace can be
#       installed at the same time as MATLAB and friends.  And as alrady noted above, the
#       dual middle stage avoids an out of space issue.
# Copy the file matlab-install/installer_input.txt into the same folder as the 
# Dockerfile. The edit this file to specify what you want to install. NOTE that 
# at a minimum you will need to have changed the following set of parameters in 
# the file.
#   fileInstallationKey
#   agreeToLicense=yes
#   Uncommented products you want to install
# When installing Polyspace with MATLAB, you'll need to have 2 versions of this file. They are renamed below
# for clarity as to which is which. The File Installation Key and product selection will be different for both.

###################################### MIDDLE BUILD STAGE 1 #######################################
## Install of MATLAB
FROM middle-stage-common as middle-stage-1

COPY matlab_installer_input.txt /matlab_installer_input.txt
RUN cd /matlab-install \
    && ./install -mode silent -inputFile /matlab_installer_input.txt
    
###################################### MIDDLE BUILD STAGE 2 #######################################
## Install of Polyspace
FROM middle-stage-common as middle-stage-2

COPY psserver_installer_input.txt /psserver_installer_input.txt
RUN cd /matlab-install \
    && ./install -mode silent -inputFile /psserver_installer_input.txt

######################################## LAST BUILD STAGE #########################################
#### Build final container image ####
FROM prebuilder

COPY --from=middle-stage-1 /usr/local/MATLAB /usr/local/MATLAB
# MAR - Flatten the install to minimize dupe files
#       This needs to be tested more, as I am not sure if there are any conflicts
#       between the file sets.  The dev team should probably validate this.
#       So far, it has worked just fine for me though.
COPY --from=middle-stage-2 /usr/local/Polyspace_Server /usr/local/MATLAB

ARG MATLAB_RELEASE

# Add a script to start MATLAB
# MAR - I had to add the dos2unix because the startmatlab.sh had dos linendings
#       that were preventing it from working.
ADD startmatlab.sh /opt/startscript/
RUN chmod +x /opt/startscript/startmatlab.sh && \
    dos2unix /opt/startscript/startmatlab.sh && \
    ln -s /usr/local/MATLAB/$MATLAB_RELEASE/bin/matlab /usr/local/bin/matlab

# MAR - Need to link Polyspace into the MATLAB install.  The silent option is
#       not currently documented; however, it will be and is being shared
#       with customers via CFE support in the interim.
RUN cd /usr/local/MATLAB/$MATLAB_RELEASE/toolbox/polyspace/pscore/pscore \
    sudo matlab -batch "polyspacesetup('install', 'silent', true)"

# Tell the container what version of MATLAB is being used
ENV MATLAB_RELEASE $MATLAB_RELEASE

# Add a user other than root to run MATLAB
RUN useradd -ms /bin/bash matlab
# Add bless that user with sudo powers
RUN echo "matlab ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/matlab \
    && chmod 0440 /etc/sudoers.d/matlab

# One of the following 2 ways of configuring the FlexLM server to use must be
# uncommented.
# MAR - Unless you decide to use the docker run invocation to pass the MLM_LICENSE_FILE
#       variable in with the -e option, which can be coupled with an SSH tunnel of BOTH
#       port 27000 and the other port, normaly randomized.  To do this, the license 
#       server does have to be configured to specify this port, on the daemon line.
# 
# MAR - Need to confirm whether the method below that matches the -e approach needs
#       to be uncommented below, or if it is unneeded.  

ARG LICENSE_SERVER
# Specify the host and port of the machine that serves the network licenses 
# if you want to bind in the license info as an environment variable. This 
# is the preferred option for licensing. It is either possible to build with 
# something like --build-arg LICENSE_SERVER=27000@MyServerName, alternatively
# you could specify the licens server directly using
#       ENV MLM_LICENSE_FILE=27000@flexlm-server-name
ENV MLM_LICENSE_FILE=$LICENSE_SERVER

# Alternatively you can put a license file (or license information) into the 
# container. You should fill this file out with the details of the license 
# server you want to use and uncomment the following line.
# The license file can also use the approach above with localhost.
#COPY network.lic /usr/local/MATLAB/$MATLAB_RELEASE/licenses/


# Finally clean up after apt-get
# MAR - Added the removal of dos2unix since it was only needed briefly
RUN apt-get remove -y dos2unix && \
    apt-get clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*        

USER matlab
WORKDIR /home/matlab

ENTRYPOINT ["/opt/startscript/startmatlab.sh"]
