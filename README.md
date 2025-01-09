
This is a Godot4.3 app that interacts with paraview over an mqtt network to request and plot streamlines in VR.

## Installation

This app depends on a number of external libraries/assets you can pull from the Godot Assetlib.

### Pre-installed libraries

*  **MQTT CLient** Version: 1.3 already installed into addons/mqtt
*  **XR Input Simulator** Version: 1.2.0 already installed into addons/xr-simulator

### Libraries you need to download and install for this project

(These are too big to ship with the project)

* **Godot XR Tools** Version: 4.3.3, installs into addons/godot-xr-tools
* **Godot OpenXR Vendors plugin for Godot 4.3** Version: 3.0.1, installs into addons/godotopenxrvendors

### Libraries not yet needed 

*  **WebRTC plugin - Godot 4.1+** Version: 1.0.6, !!install into addons/webrtc
*  **TwoVoip** Version: v3.4 install into addons/twovoip
*  **Godot XR Autohands** Version: 1.1 installs into addons/xr-autohandstracker

## Operation

The paraview data is in directory data/case-smoothmesh-AL10  
There is a python program `paramqtt.py` that you execute from `pvpython`
This takes a while to load, but when it does it responds to json requests 
for streamlines to be calculated on the channel `paraview/streamdef` 
and it saves its responses to `paraview/streamdata`



