# Copyright 2023-2025 The MathWorks, Inc.

# To specify which MATLAB release to install in the container, edit the value of the MATLAB_RELEASE argument.
# Use uppercase to specify the release, for example: ARG MATLAB_RELEASE=R2021b
ARG MATLAB_RELEASE=R2025b

# Specify the extra products to install into the image. These products can either be toolboxes or support packages.
#ARG ADDITIONAL_PRODUCTS="Symbolic_Math_Toolbox Deep_Learning_Toolbox_Model_for_ResNet-50_Network"

ARG ADDITIONAL_PRODUCTS="5G_Toolbox \
AUTOSAR_Blockset \
Aerospace_Blockset \
Aerospace_Toolbox \
Antenna_Toolbox \
Audio_Toolbox \
Automated_Driving_Toolbox \
Bioinformatics_Toolbox \
Bluetooth_Toolbox \
C2000_Microcontroller_Blockset \
Communications_Toolbox \
Computer_Vision_Toolbox \
Control_System_Toolbox \
Curve_Fitting_Toolbox \
DDS_Blockset \
DSP_HDL_Toolbox \
DSP_System_Toolbox \
Database_Toolbox \
Datafeed_Toolbox \
Deep_Learning_HDL_Toolbox \
Deep_Learning_Toolbox \
Econometrics_Toolbox \
Embedded_Coder \
Financial_Instruments_Toolbox \
Financial_Toolbox \
Fixed-Point_Designer \
Fuzzy_Logic_Toolbox \
GPU_Coder \
Global_Optimization_Toolbox \
HDL_Coder \
HDL_Verifier \
Image_Acquisition_Toolbox \
Image_Processing_Toolbox \
Industrial_Communication_Toolbox \
Instrument_Control_Toolbox \
LTE_Toolbox \
Lidar_Toolbox \
MATLAB \
MATLAB_Coder \
MATLAB_Compiler \
MATLAB_Compiler_SDK \
MATLAB_Parallel_Server \
MATLAB_Production_Server \
MATLAB_Report_Generator \
MATLAB_Test \
MATLAB_Web_App_Server \
Mapping_Toolbox \
Medical_Imaging_Toolbox \
Mixed-Signal_Blockset \
Model_Predictive_Control_Toolbox \
Model-Based_Calibration_Toolbox \
Motor_Control_Blockset \
Navigation_Toolbox \
Optimization_Toolbox \
Parallel_Computing_Toolbox \
Partial_Differential_Equation_Toolbox \
Phased_Array_System_Toolbox \
Polyspace_Bug_Finder \
Polyspace_Bug_Finder_Server \
Polyspace_Code_Prover \
Polyspace_Code_Prover_Server \
Polyspace_Test \
Powertrain_Blockset \
Predictive_Maintenance_Toolbox \
RF_Blockset \
RF_PCB_Toolbox \
RF_Toolbox \
ROS_Toolbox \
Radar_Toolbox \
Reinforcement_Learning_Toolbox \
Requirements_Toolbox \
Risk_Management_Toolbox \
Robotics_System_Toolbox \
Robust_Control_Toolbox \
Satellite_Communications_Toolbox \
Sensor_Fusion_and_Tracking_Toolbox \
SerDes_Toolbox \
Signal_Integrity_Toolbox \
Signal_Processing_Toolbox \
SimBiology \
SimEvents \
Simscape \
Simscape_Battery \
Simscape_Driveline \
Simscape_Electrical \
Simscape_Fluids \
Simscape_Multibody \
Simulink \
Simulink_3D_Animation \
Simulink_Check \
Simulink_Coder \
Simulink_Compiler \
Simulink_Control_Design \
Simulink_Coverage \
Simulink_Design_Optimization \
Simulink_Design_Verifier \
Simulink_Desktop_Real-Time \
Simulink_Fault_Analyzer \
Simulink_PLC_Coder \
Simulink_Real-Time \
Simulink_Report_Generator \
Simulink_Test \
SoC_Blockset \
Stateflow \
Statistics_and_Machine_Learning_Toolbox \
Symbolic_Math_Toolbox \
System_Composer \
System_Identification_Toolbox \
Text_Analytics_Toolbox \
UAV_Toolbox \
Vehicle_Dynamics_Blockset \
Vehicle_Network_Toolbox \
Vision_HDL_Toolbox \
WLAN_Toolbox \
Wavelet_Toolbox \
Wireless_HDL_Toolbox \
Wireless_Testbench \
6G_Exploration_Library_for_5G_Toolbox \
ASIC_Testbench_for_HDL_Verifier \
Aerospace_Blockset_Interface_for_Unreal_Engine_Projects \
Audio_Toolbox_Interface_for_SpeechBrain_and_Torchaudio_Libraries \
Automated_Driving_Toolbox_Importer_for_Zenrin_Japan_Map_API_3.0_(Itsumo_NAVI_API_3.0)_Service \
Automated_Driving_Toolbox_Interface_for_Unreal_Engine_Projects \
Automated_Driving_Toolbox_Model_for_Lidar_Lane_Detection \
Automated_Driving_Toolbox_Test_Suite_for_Euro_NCAP_Protocols \
Automated_Visual_Inspection_Library_for_Computer_Vision_Toolbox \
CI/CD_Automation_for_Simulink_Check \
Communications_Toolbox_Support_Package_for_Analog_Devices_ADALM-Pluto_Radio \
Communications_Toolbox_Support_Package_for_RTL-SDR_Radio \
Communications_Toolbox_Support_Package_for_USRP_Embedded_Series_Radio \
Communications_Toolbox_Support_Package_for_USRP_Radio \
Communications_Toolbox_Wireless_Network_Simulation_Library \
Component_Deployment_Guideline_for_Embedded_Coder \
Computer_Vision_Toolbox_Interface_for_OpenCV_in_MATLAB \
Computer_Vision_Toolbox_Interface_for_OpenCV_in_Simulink \
Computer_Vision_Toolbox_Model_for_BiSeNet_v2_Semantic_Segmentation_Network \
Computer_Vision_Toolbox_Model_for_Inflated-3D_Video_Classification \
Computer_Vision_Toolbox_Model_for_Mask_R-CNN_Instance_Segmentation \
Computer_Vision_Toolbox_Model_for_Object_Keypoint_Detection \
Computer_Vision_Toolbox_Model_for_Pose_Mask_R-CNN_6-DoF_Object_Pose_Estimation \
Computer_Vision_Toolbox_Model_for_R(2+1)D_Video_Classification \
Computer_Vision_Toolbox_Model_for_RAFT_Optical_Flow_Estimation \
Computer_Vision_Toolbox_Model_for_RTMDet_Object_Detection \
Computer_Vision_Toolbox_Model_for_RetinaFace_Face_Detection \
Computer_Vision_Toolbox_Model_for_SOLOv2_Instance_Segmentation \
Computer_Vision_Toolbox_Model_for_SlowFast_Video_Classification \
Computer_Vision_Toolbox_Model_for_Text_Detection \
Computer_Vision_Toolbox_Model_for_Vision_Transformer_Network \
Computer_Vision_Toolbox_Model_for_YOLO_v2_Object_Detection \
Computer_Vision_Toolbox_Model_for_YOLO_v3_Object_Detection \
Computer_Vision_Toolbox_Model_for_YOLO_v4_Object_Detection \
Computer_Vision_Toolbox_OCR_Language_Data \
Database_Toolbox_Interface_for_Neo4j_Bolt_Protocol \
Deep_Learning_HDL_Toolbox_Support_Package_for_AMD_FPGA_and_SoC_Devices \
Deep_Learning_HDL_Toolbox_Support_Package_for_Intel_FPGA_and_SoC_Devices \
Deep_Learning_Toolbox_Converter_for_ONNX_Model_Format \
Deep_Learning_Toolbox_Converter_for_PyTorch_Model_Format \
Deep_Learning_Toolbox_Converter_for_TensorFlow_models \
Deep_Learning_Toolbox_Importer_for_Caffe_Models \
Deep_Learning_Toolbox_Interface_for_TensorFlow_Lite \
Deep_Learning_Toolbox_Model_Compression_Library \
Deep_Learning_Toolbox_Model_for_AlexNet_Network \
Deep_Learning_Toolbox_Model_for_DarkNet-19_Network \
Deep_Learning_Toolbox_Model_for_DarkNet-53_Network \
Deep_Learning_Toolbox_Model_for_DenseNet-201_Network \
Deep_Learning_Toolbox_Model_for_EfficientNet-b0_Network \
Deep_Learning_Toolbox_Model_for_GoogLeNet_Network \
Deep_Learning_Toolbox_Model_for_Inception-ResNet-v2_Network \
Deep_Learning_Toolbox_Model_for_Inception-v3_Network \
Deep_Learning_Toolbox_Model_for_MobileNet-v2_Network \
Deep_Learning_Toolbox_Model_for_NASNet-Large_Network \
Deep_Learning_Toolbox_Model_for_NASNet-Mobile_Network \
Deep_Learning_Toolbox_Model_for_Places365-GoogLeNet_Network \
Deep_Learning_Toolbox_Model_for_ResNet-101_Network \
Deep_Learning_Toolbox_Model_for_ResNet-18_Network \
Deep_Learning_Toolbox_Model_for_ResNet-50_Network \
Deep_Learning_Toolbox_Model_for_ShuffleNet_Network \
Deep_Learning_Toolbox_Model_for_VGG-16_Network \
Deep_Learning_Toolbox_Model_for_VGG-19_Network \
Deep_Learning_Toolbox_Model_for_Xception_Network \
Deep_Learning_Toolbox_Verification_Library \
Embedded_Coder_Interface_to_QEMU_Emulator \
Embedded_Coder_Support_Package_For_Linux_Applications \
Embedded_Coder_Support_Package_for_AMD_SoC_Devices \
Embedded_Coder_Support_Package_for_ARM_Cortex-A_Processors \
Embedded_Coder_Support_Package_for_ARM_Cortex-M_Processors \
Embedded_Coder_Support_Package_for_Intel_SoC_Devices \
Embedded_Coder_Support_Package_for_Qualcomm_Hexagon_Processors \
Embedded_Coder_Support_Package_for_STMicroelectronics_STM32_Processors \
Ephemeris_Data_for_Aerospace_Toolbox \
Extended_Tire_Features_for_Vehicle_Dynamics_Blockset \
FMU_Builder_For_Simulink \
GPU_Coder_Interface_for_Deep_Learning_Libraries \
GUIDE_to_App_Designer_Migration_Tool_for_MATLAB \
Geoid_Data_for_Aerospace_Toolbox \
HDL_Coder_Support_Package_for_AMD_FPGA_and_SoC_Devices \
HDL_Coder_Support_Package_for_Intel_FPGA_and_SoC_Devices \
HDL_Coder_Support_Package_for_Microchip_FPGA_and_SoC_Devices \
HDL_Verifier_Support_Package_for_AMD_FPGA_and_SoC_Devices \
HDL_Verifier_Support_Package_for_Intel_FPGA_Boards \
HDL_Verifier_Support_Package_for_Microsemi_FPGA_Boards \
Hyperspectral_Imaging_Library_for_Image_Processing_Toolbox \
Image_Acquisition_Toolbox_Support_Package_for_DCAM_Hardware \
Image_Acquisition_Toolbox_Support_Package_for_OS_Generic_Video_Interface \
Image_Processing_Toolbox_Image_Data \
Image_Processing_Toolbox_Model_for_Segment_Anything_Model \
Instrument_Control_Toolbox_Support_Package_for_Total_Phase_Aardvark_I2C/SPI_Interface \
Integro-Differential_Modeling_Framework_for_MATLAB \
Large-Scale_Cloud_Simulation_for_Simulink \
Lidar_Toolbox_Model_for_PointNet++_Classification \
Lidar_Toolbox_Model_for_RandLA-Net_Semantic_Segmentation \
Lidar_Toolbox_Support_Package_for_Hokuyo_LiDAR_Sensors \
Lidar_Toolbox_Support_Package_for_Ouster_Lidar_Sensors \
Lidar_Toolbox_Support_Package_for_Velodyne_LiDAR_Sensors \
MATLAB_Basemap_Data_-_bluegreen \
MATLAB_Basemap_Data_-_colorterrain \
MATLAB_Basemap_Data_-_grayland \
MATLAB_Basemap_Data_-_grayterrain \
MATLAB_Basemap_Data_-_landcover \
MATLAB_Client_for_MATLAB_Production_Server \
MATLAB_Coder_Interface_for_Deep_Learning_Libraries \
MATLAB_Coder_Interface_for_Visual_Studio_Code_Debugging \
MATLAB_Coder_Support_Package_for_NVIDIA_Jetson_and_NVIDIA_DRIVE_Platforms \
MATLAB_Support_Package_for_Android_Sensors \
MATLAB_Support_Package_for_Apple_iOS_Sensors \
MATLAB_Support_Package_for_Arduino_Hardware \
MATLAB_Support_Package_for_LEGO_MINDSTORMS_EV3_Hardware \
MATLAB_Support_Package_for_Quantum_Computing \
MATLAB_Support_Package_for_Raspberry_Pi_Hardware \
MATLAB_Support_Package_for_USB_Webcams \
MATLAB_Support_for_HEIF/HEIC_Image_Format \
Machine_Learning_Pipelines_for_Statistics_and_Machine_Learning_Toolbox_(Beta) \
Medical_Imaging_Toolbox_Interface_for_Cellpose \
Medical_Imaging_Toolbox_Interface_for_MONAI_Label_Library \
Medical_Imaging_Toolbox_Model_for_Medical_Segment_Anything_Model \
Mixed-Signal_Blockset_Models \
Modelscape_for_MATLAB \
Multi-Version_Co-Simulation_for_Simulink \
Powertrain_Blockset_Drive_Cycle_Data \
RF_Blockset_Models_for_Analog_Devices_RF_Transceivers \
ROS_Toolbox_Support_Package_for_TurtleBot-Based_Robots \
Robotics_System_Toolbox_Interface_for_Unreal_Engine_Projects \
Robotics_System_Toolbox_Offroad_Autonomy_Library \
Robotics_System_Toolbox_Robot_Library_Data \
Robotics_System_Toolbox_Support_Package_for_Kinova_Gen3_Manipulators \
Robotics_System_Toolbox_Support_Package_for_Universal_Robots_UR_Series_Manipulators \
Scenario_Builder_for_Automated_Driving_Toolbox \
Signal_Processing_Toolbox_Support_Package_for_Linux_IIO_Devices \
Simulink_3D_Animation_Interface_for_Unreal_Engine_Projects \
Simulink_Coder_Support_Package_for_BeagleBone_Blue_Hardware \
Simulink_Support_Package_for_Android_Devices \
Simulink_Support_Package_for_Arduino_Hardware \
Simulink_Support_Package_for_LEGO_MINDSTORMS_EV3_Hardware \
Simulink_Support_Package_for_Parrot_Minidrones \
Simulink_Support_Package_for_Raspberry_Pi_Hardware \
SoC_Blockset_Support_Package_for_AMD_FPGA_and_SoC_Devices \
SoC_Blockset_Support_Package_for_Embedded_Linux_Devices \
SoC_Blockset_Support_Package_for_Intel_Devices \
Streaming_Data_Framework_for_MATLAB_Production_Server \
Text_Analytics_Toolbox_Model_for_BERT-Base_Multilingual_Cased_Network \
Text_Analytics_Toolbox_Model_for_BERT-Base_Network \
Text_Analytics_Toolbox_Model_for_BERT-Large_Network \
Text_Analytics_Toolbox_Model_for_BERT-Mini_Network \
Text_Analytics_Toolbox_Model_for_BERT-Small_Network \
Text_Analytics_Toolbox_Model_for_BERT-Tiny_Network \
Text_Analytics_Toolbox_Model_for_all-MiniLM-L12-v2_Network \
Text_Analytics_Toolbox_Model_for_all-MiniLM-L6-v2_Network \
Text_Analytics_Toolbox_Model_for_fastText_English_16_Billion_Token_Word_Embedding \
Text_Analytics_Toolbox_Model_from_UDify_Data \
UAV_Toolbox_Interface_for_Unreal_Engine_Projects \
UAV_Toolbox_Support_Package_for_PX4_Autopilots \
Variant_Manager_for_Simulink \
Vehicle_Dynamics_Blockset_Interface_for_Unreal_Engine_Projects \
Vehicle_Dynamics_Blockset_Maneuver_Data \
WINNER_II_Channel_Model_for_Communications_Toolbox \
Wireless_Testbench_Support_Package_for_NI_USRP_Radios \
Airport_Scene \
Construction_Site_Scene \
Curved_Road_Scene \
Double_Lane_Change_Scene \
Empty_Grass_Scene \
Empty_Scene \
Large_Parking_Lot_Scene \
Offroad_Pit_Mining_Scene \
Open_Surface_Scene \
Parking_Lot_Scene \
Straight_Road_Scene \
Suburban_Scene \
TensorRT_Library \
US_City_Block_Scene \
US_Highway_Scene \
Virtual_MCity_Scene \
ZalaZONE_Automotive_Proving_Ground_High-speed_Handling_Course_Scene \
ZalaZONE_Automotive_Proving_Ground_Hill_Tracks_Scene \
ZalaZONE_Automotive_Proving_Ground_Smart_City_Scene"

# Specify the fonts packages to install into the image. The default value below installs fonts for ja_JP-UTF-8 locales support.
ARG FONTS_PACKAGES="fonts-vlgothic ibus-mozc"

# Specify the extra Ubuntu APT packages to install into the image.
ARG ADDITIONAL_APT_PACKAGES="" 

# This Dockerfile builds on the Ubuntu-based mathworks/matlab image.
# To check the available matlab images, see: https://hub.docker.com/r/mathworks/matlab
FROM mathworks/matlab:$MATLAB_RELEASE

# Declare the global argument to use at the current build stage
ARG MATLAB_RELEASE
ARG ADDITIONAL_PRODUCTS
ARG FONTS_PACKAGES
ARG ADDITIONAL_APT_PACKAGES

# By default, the MATLAB container runs as user "matlab". To install mpm dependencies, switch to root.
USER root

# Install mpm dependencies
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install --no-install-recommends --yes \
        wget \
        bzip2 \
        xz-utils \
        ca-certificates \
        ${FONTS_PACKAGES} \
        ${ADDITIONAL_APT_PACKAGES} \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# Run mpm to install MathWorks products into the existing MATLAB installation directory,
# and delete the mpm installation afterwards.
# Modify it by setting the ADDITIONAL_PRODUCTS defined above,
# e.g. ADDITIONAL_PRODUCTS="Statistics_and_Machine_Learning_Toolbox Parallel_Computing_Toolbox MATLAB_Coder".
# If mpm fails to install successfully then output the logfile to the terminal, otherwise cleanup.

# Switch to user matlab, and pass in $HOME variable to mpm,
# so that mpm can set the correct root folder for the support packages.
WORKDIR /tmp
USER matlab
RUN wget -q https://www.mathworks.com/mpm/glnxa64/mpm \
    && chmod +x mpm \
    && EXISTING_MATLAB_LOCATION=$(dirname $(dirname $(readlink -f $(which matlab)))) \
    && sudo HOME=${HOME} ./mpm install \
        --destination=${EXISTING_MATLAB_LOCATION} \
        --release=${MATLAB_RELEASE} \
        --products ${ADDITIONAL_PRODUCTS} \
    || (echo "MPM Installation Failure. See below for more information:" && cat /tmp/mathworks_root.log && false) \
    && sudo rm -rf mpm /tmp/mathworks_root.log

# When running the container a license file can be mounted,
# or a license server can be provided as an environment variable.
# For more information, see https://hub.docker.com/r/mathworks/matlab

# Alternatively, you can provide a license server to use
# with the docker image while building the image.
# Specify the host and port of the machine that serves the network licenses
# if you want to bind in the license info as an environment variable.
# You can also build with something like --build-arg LICENSE_SERVER=27000@MyServerName,
# in which case you should uncomment the following two lines.
# If these lines are uncommented, $LICENSE_SERVER must be a valid license
# server or browser mode will not start successfully.
# ARG LICENSE_SERVER
# ENV MLM_LICENSE_FILE=$LICENSE_SERVER

# The following environment variables allow MathWorks to understand how this MathWorks
# product is being used. This information helps us make MATLAB even better.
# Your content, and information about the content within your files, is not shared with MathWorks.
# To opt out of this service, delete the environment variables defined in the following line.
# See the Help Make MATLAB Even Better section in the accompanying README to learn more:
# https://github.com/mathworks-ref-arch/matlab-dockerfile#help-make-matlab-even-better
ENV MW_DDUX_FORCE_ENABLE=true MW_CONTEXT_TAGS=$MW_CONTEXT_TAGS,MATLAB:TOOLBOXES:DOCKERFILE:V1

WORKDIR /home/matlab
# Inherit ENTRYPOINT and CMD from base image.
