
## Requirements

* NI Labview 2019 64bit 
(https://www.ni.com/en-us/support/downloads/software-products/download.labview.html#329483)
* NI DAQmx 
(https://www.ni.com/en-us/support/downloads/drivers/download.ni-daqmx.html#382067)
* NI Vision Acquisition
(https://www.ni.com/en-us/support/downloads/drivers/download.vision-acquisition-software.html#367318)
* Andor LabView SDK3
(https://andor.oxinst.com/downloads/view/sdk3-for-labview-3.15.30065.0)

    We use version 3.15.30000.0, which is no longer exist on the website.
* DMD driver ALP 4.3
(https://www.vialux.de/en/download.html)

    We use ALP43_install-R706.exe, which is no longer exist on the website. Our program may be not compatible with the newer version ALP43_install-R765.exe.

    To use API in labview, import the library by 'Tools->Import->Shared library(.dll)' after installing the driver.  (https://knowledge.ni.com/KnowledgeArticleDetails?id=kA00Z0000019Ls1SAE&l=en-GB)

## Wiring Guide

* Dev1/ao1 is used to control the speed of the rotary stage.

* Dev1/PFI9 links to the IR detector, which triggers the following digital output task and measures the speed of rotary stage using Dev1/ctr0.

* Dev1/port0/line0:2 link to the external trigger of DMD (line0), camera (line1) and LED (line2).

## Software Guide

### 1. Use 'Free Run' mode to test rotary stage, camera, DMD and LED.
* Enter a voltage at 'rotary voltage', the stage should start to move. 

    Click the button beside 'rotary voltage', 'rps' and 'T(ms)' should show the speed.

    ![](./img_for_readme/a1.png)
* Click 'DMD' and 'LED' button to see if they can be controlled.

    ![](./img_for_readme/a2.png)

* 'open camera'->'apply settings'->'live'->'stop live' to test the sCMOS camera. 
    
    Use 'save images' to acquire and save some images. (If the camera temperature is high, turn on 'SensorCooling' in micro-manager)

    ![](./img_for_readme/a3.png)

### 2. Use 'Calibration' mode to get images for surface detection.
* Set 'signal time' to a number that is a little smaller than 'T(ms)'. Set 'Frame number to 1 for normal sample, to 50 for neurons. After 'apply settings' -> 'start cali', there will be some images in the folder '.\default_image_path\default_save_path\'. 

    ![](./img_for_readme/a4.png)

### 3. Surface detection
* Fit the surface with algorithms or manually. We put beads on a lens and use it as our sample here.

    ![](./img_for_readme/a5.png)


### 4. Use 'Acquisition' mode to image the surface
* After surface detection, there should be a folder containing DMD patterns. Set 'acq pattern path' to this folder. 'apply settings'->'start acq', there will be some images in the '.\default_image_path\default_save_path\'. 

    ![](./img_for_readme/a6.png)
