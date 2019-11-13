# zlaser_sdk_ros

This package is used to control Laser Projector ZLP1 via ROS using ZLASER SDK.

### Usage ###
Once the setup is done it is possible to use libraries from this repo to manage the projector.

Import projector manager on your script and feel free to use it:
```
#!/usr/bin/env python3

from zlaser_sdk_ros.projector_manager import ProjectorManager
```

Or launch the ros node included in this package to connect to projector

        roslaunch zlaser_sdk_ros projector_zlp1.launch

Available services:

* `/projector_srv/connect`: connect to service and active projector.  
* `/projector_srv/disconnect`:  disconnect from service and deactive projector.
* `/projector_srv/setup`: connect to service, active projector, check license and show available coordinate systems.
* `/projector_srv/load_license`: send license to service.
* `/projector_srv/cs`: define a new coordinate system.
* `/projector_srv/project`: define a shape to project and start projection. Currently, only circle is implemented.
* `/projector_srv/stop`: stop projection.

### Setup ###

* Install dependencies
* Clone this repo 
* Compile

        catkin_make

* Source your workspace
* Connect projector to PC and set a network on IP `192.168.10.9` and submask `255.255.255.0`
* The server is running inside the projector under `192.168.11.11` on port `9090`.
* Projector is always reachable under `192.168.10.10`. 

### Dependencies ###

* [ROS Kinetic](http://wiki.ros.org/kinetic/Installation/Ubuntu)
* Python 3.5 under `#!/usr/bin/env python3` and pip3

        sudo apt-get install python3-pip

* thriftpy:

        pip3 install thriftpy

### Known issues ###
* RecursionError: maximum recursion depth exceeded while calling a Python object: this means that ethernet connection have not been stablished. Restart projector, wait for green LED's and connect again.
* Error processing request: FunctionModuleNotExistent(fModUID=''): this means that license could not have registered zFunctModRegister3d or that you are trying to create a coordinate system that already exists.
* Error processing request: 'ProjectorManager' object has no attribute 'projector_id': this means that projector instance has not been created. Call to `connect or setup service` to create it first.
* Error processing request: ServiceInterfaceHandler::TriggerProjection() bv::InvalidState(What: Keine Projektoren verbunden!): license problems. Close node and restart again. Perform call in this order: setup, cs, project

### Help ###

* Ines M. Lara - imlara@catec.aero
* Other community or team contact