# Copyright 2019 - 2021 The MathWorks, Inc.

# We use the latest dependency container for MathWorks products. You can find more 
# info on the variety of different tags available for the dependency container and 
# the Dockerfiles used to build them at https://github.com/mathworks-ref-arch/container-images/tree/master/matlab-deps
FROM mathworks/matlab-deps as prebuilder

LABEL  MAINTAINER=MathWorks

# To avoid inadvertently polluting the / directory, use root's home directory 
# while running MATLAB.
USER root
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
#   Uncomment products you want to install
ADD matlab_installer_input.txt /matlab_installer_input.txt

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
# you could specify the license server directly using
#       ENV MLM_LICENSE_FILE=27000@flexlm-server-name
ENV MLM_LICENSE_FILE=$LICENSE_SERVER

# Alternatively you can put a license file (or license information) into the 
# container. You should fill this file out with the details of the license 
# server you want to use and uncomment the following line.
# ADD network.lic /usr/local/MATLAB/licenses/
   
USER matlab
WORKDIR /home/matlab

# Uncomment and maybe change the following line to setup mex in your container
#RUN /usr/local/MATLAB/bin/mex -v -setup C++

ENTRYPOINT ["/opt/startscript/startmatlab.sh"]
