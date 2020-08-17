#!/usr/bin/env python3

# Copyright (c) 2020, FADA-CATEC

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""This module imports the zlp and utils libraries and manages the functionalities provided from a layer of abstraction, simplifying the 
task of developing advanced applications."""

import sys
import time
import math
# from z_laser_projector.zlp import ProjectorClient, CoordinateSystem, ProjectionElementControl # noqa?
# from z_laser_projector.utils import CoordinateSystemParameters, ProjectionElementParameters # noqa?
from zlp import ProjectorClient, CoordinateSystem, ProjectionElementControl
from utils import CoordinateSystemParameters, ProjectionElementParameters

class ProjectorManager:
    """This class envolves the methods from the libraries imported.
    
    Args:
        projector_IP (str): IP number of projector device
        server_IP (str): IP number of service running at projector device
        connection_port (int): connection port number 

    Attributes:
        projector_IP (str): IP number of projector device
        server_IP (str): IP number of service running at projector device
        connection_port (int): connection port number 
        license_path (str): folder path where Z-Laser license file is located
        projector_id (str): identification number of projector device
        coordinate_system (str): name of coordinate system with which the user is operating currently 
            ('current operating coordinate system')
        current_user_T_points (list[float]): list of user reference system points [T1,T2,T3,T4]
        projector_client (object): ProjectorClient object from utils library
    """
    def __init__(self, projector_IP = "192.168.10.10", server_IP = "192.168.10.11", connection_port = 9090, lic_path=""):
        """Initialize the ProjectorManager object."""
        self.projector_IP = projector_IP
        self.server_IP = server_IP
        self.connection_port = connection_port
        self.license_path = lic_path
        self.projector_id = ""
        self.coordinate_system = ""
        self.current_user_T_points = []

        self.projector_client = ProjectorClient() 

    def connect_and_setup(self):
        """Prepare projector to be used: connect, load license and activate.
        
        Raises:
            SystemError: Raises an exception
        """
        try:
            self.client_server_connect()       
            self.load_license(self.license_path)
            self.activate()
            self.geotree_operator_create()
        
        except Exception as e:
            raise SystemError(e)

    def client_server_connect(self):
        """Connect to thrift server of ZLP-Service.

        Raises:
            ConnectionError
        """
        success,message = self.projector_client.connect(self.server_IP, self.connection_port)
        if not success:
            raise ConnectionError(message)

    def client_server_disconnect(self):
        """Disconnect from thrift server of ZLP-Service.

        Raises:
            ConnectionError:
        """
        success,message = self.projector_client.disconnect()
        if not success:
            raise ConnectionError(message)

    def load_license(self,license_path):
        """Transfer license file to service.

        Args:
            license_path (str): path of the license file

        Raises:
            FileNotFoundError:
        """
        success,message = self.projector_client.transfer_license(license_path)
        if not success:
            raise FileNotFoundError(message)

    def activate(self):
        """Activate projector once it is connected and license is transfered.

        Raises:
            SystemError:
        """
        self.projector_id,success,message = self.projector_client.activate_projector(self.projector_IP)
        if not success:
            raise SystemError(message)
    
        success,message = self.projector_client.check_license()
        if not success:
            raise SystemError(message)

    def deactivate(self):
        """Deactivate projector.

        Raises:
            SystemError:
        """
        success,message = self.projector_client.deactivate_projector()
        if not success:
            raise SystemError(message)

    def geotree_operator_create(self):
        """Create geotree operator to handle reference systems and projection elements.

        Raises:
            SystemError:
        """
        module_id,success,message = self.projector_client.function_module_create()
        if not success:
            raise SystemError(message)

        thrift_client = self.projector_client.get_thrift_client()

        self.cs_element = CoordinateSystem(self.projector_id, module_id, thrift_client)
        self.projection_element = ProjectionElementControl(module_id,thrift_client)

    def start_projection(self):
        """Start projection of elements associated to the current reference system.

        Raises:
            Warning:
            SystemError:
        """
        if not self.coordinate_system:
            raise Warning("No Current Coordinate System set yet.")

        success,message = self.projector_client.start_project(self.coordinate_system)
        if not success:
            raise SystemError(message)

    def stop_projection(self):
        """Stop projection of all elements.

        Raises:
            SystemError:
        """
        success,message = self.projector_client.stop_project()
        if not success:
            raise SystemError(message)

    def get_coordinate_systems(self):
        """Get list of all defined reference systems.

        Raises:
            SystemError:
        """
        cs_list,success,message = self.cs_element.coordinate_system_list()
        if not success:
            raise SystemError(message)

        return cs_list

    def define_coordinate_system(self,cs_params):
        """Define a new coordinate reference system.

        Args:
            cs_params (list): list of necessary parameters to define a new reference system (coordinates of reference system points)

        Raises:
            SystemError:
        """
        coord_sys,self.current_user_T_points,success,message = self.cs_element.define_cs(cs_params)
        if not success:
            raise SystemError(message)
        try:
            self.register_coordinate_system(coord_sys)
            self.set_coordinate_system(coord_sys)
        except SystemError as e:
            raise SystemError(e)

    def register_coordinate_system(self,coord_sys):
        """Register new coordinate reference system.

        Args:
            cs_params (list): list of parameters from the new defined reference system

        Raises:
            SystemError:
        """
        success,message = self.cs_element.register_cs(coord_sys)
        if not success:
            raise SystemError(message)
        
    def set_coordinate_system(self,coord_sys):
        """Set the current operating reference system.

        Args:
            coord_sys (str): name of reference coordinate system

        Raises:
            SystemError:
        """
        success,message = self.cs_element.set_cs(coord_sys)
        if success:
            self.coordinate_system = coord_sys
        if not success:
            raise SystemError(message)
        
    def show_coordinate_system(self,secs):
        """Project the reference points, origin axes and frame of the current operating reference system, 
        on the projection surface.

        Args:
            secs (int): number of projection seconds on the surface 

        Raises:
            SystemError:
        """
        if not self.coordinate_system:
            message = "Coordinate system does not exist."
            raise SystemError(message)
        
        success,message = self.cs_element.show_cs(self.coordinate_system, secs)
        if not success:
            raise SystemError(message)
        try:
            self.cs_frame_unhide()
            self.cs_axes_unhide()
            self.start_projection()
            time.sleep(secs)
            self.stop_projection()
            self.cs_frame_hide()  
            self.cs_axes_hide()
        except SystemError as e:
            raise SystemError(e)       

    def remove_coordinate_system(self,coord_sys):
        """Delete current reference system.

        Args:
            coord_sys (str): name of reference coordinate system 

        Raises:
            SystemError:
        """
        success,message = self.cs_element.remove_cs(coord_sys)
        if success:
            self.coordinate_system = ""
            self.current_user_T_points = []
        else:
            raise SystemError(message)
        
    def create_polyline(self,proj_elem_params):
        """Create a line as new projection figure, associated to the current reference system.

        Args:
            proj_elem_params (object): object with necessary parameters to identify a polyline 

        Raises:
            SystemError:
        """
        if not self.coordinate_system:
            message = "There is not a current coordinate system. Define or set one first."
            raise SystemError(message)
        
        success,message = self.projection_element.define_polyline(self.coordinate_system,proj_elem_params)
        if not success:
            raise SystemError(message)
        
    def hide_shape(self, proj_elem_params):
        """Hide a figure from current reference system.

        Args:
            proj_elem_params (object): object with necessary parameters to identify a projection element

        Raises:
            SystemError:
        """
        success,message = self.projection_element.deactivate_shape(proj_elem_params)
        if not success:
            raise SystemError(message)
        
    def unhide_shape(self,proj_elem_params):
        """Unhide a figure from current reference system.

        Args:
            proj_elem_params (object): object with necessary parameters to identify a projection element 

        Raises:
            SystemError:
        """
        success,message = self.projection_element.reactivate_shape(proj_elem_params)
        if not success:
            raise SystemError(message)
        
    def remove_shape(self,proj_elem_params):
        """Delete a figure from current reference system.

        Args:
            proj_elem_params (object): object with necessary parameters to identify a projection element  

        Raises:
            SystemError:
        """
        success,message = self.projection_element.delete_shape(proj_elem_params)
        if not success:
            raise SystemError(message)
    
    def cs_axes_create(self,cs_params):
        """Create projection elements of user reference system origin axes.

        Args:
            cs_params (object): object with necessary parameters to identify a coordinate system

        Raises:
            SystemError:
        """
        proj_elem_params = ProjectionElementParameters()
        success,message = self.projection_element.cs_axes_create(cs_params,proj_elem_params)
        if not success:
            raise SystemError(message)

        try:
            self.cs_axes_hide()
        except SystemError as e:
            raise SystemError(e)
    
    def cs_frame_create(self,cs_params):
        """Create projection elements of user reference system frame.

        Args:
            T (list): list of the User System Reference Points
            cs_params (list): list of definition parameters of the reference system

        Raises:
            SystemError:
        """
        proj_elem_params = ProjectionElementParameters()
        success,message = self.projection_element.cs_frame_create(cs_params,proj_elem_params,self.current_user_T_points)
        if not success:
            raise SystemError(message)

        try:
           self.cs_frame_hide()
        except SystemError as e:
            raise SystemError(e)

    def cs_axes_unhide(self):
        """Unhide user reference system origin axes for later projection.

        Raises:
            SystemError:
        """
        proj_elem_params = ProjectionElementParameters()
        proj_elem_params.group_name = self.coordinate_system + "_origin"
        proj_elem_params.shape_type = "polyline"
        
        try:
            proj_elem_params.shape_id = "axis_x"
            self.unhide_shape(proj_elem_params)            
            proj_elem_params.shape_id = "axis_y"
            self.unhide_shape(proj_elem_params)
            proj_elem_params.shape_id = "axis_x_arrow1"
            self.unhide_shape(proj_elem_params)
            proj_elem_params.shape_id = "axis_x_arrow2"
            self.unhide_shape(proj_elem_params)
            proj_elem_params.shape_id = "axis_y_arrow1"
            self.unhide_shape(proj_elem_params)
            proj_elem_params.shape_id = "axis_y_arrow2"
            self.unhide_shape(proj_elem_params)
        except SystemError as e:
            raise SystemError(e)
        
    def cs_axes_hide(self):
        """Hide user reference system origin axes.

        Raises:
            SystemError:
        """
        proj_elem_params = ProjectionElementParameters()
        proj_elem_params.group_name = self.coordinate_system + "_origin"
        proj_elem_params.shape_type = "polyline"
        
        try:
            proj_elem_params.shape_id = "axis_x"
            self.hide_shape(proj_elem_params)            
            proj_elem_params.shape_id = "axis_y"
            self.hide_shape(proj_elem_params)
            proj_elem_params.shape_id = "axis_x_arrow1"
            self.hide_shape(proj_elem_params)
            proj_elem_params.shape_id = "axis_x_arrow2"
            self.hide_shape(proj_elem_params)
            proj_elem_params.shape_id = "axis_y_arrow1"
            self.hide_shape(proj_elem_params)
            proj_elem_params.shape_id = "axis_y_arrow2"
            self.hide_shape(proj_elem_params)
        except SystemError as e:
            raise SystemError(e)
        
    def cs_frame_unhide(self):
        """Unhide frame of user reference system for later projection.

        Raises:
            SystemError:
        """
        proj_elem_params = ProjectionElementParameters()
        proj_elem_params.group_name = self.coordinate_system + "_frame"
        proj_elem_params.shape_type = "polyline"
        
        try:
            proj_elem_params.shape_id = "T1_T2"
            self.unhide_shape(proj_elem_params)
            proj_elem_params.shape_id = "T2_T3"
            self.unhide_shape(proj_elem_params)
            proj_elem_params.shape_id = "T3_T4"
            self.unhide_shape(proj_elem_params)
            proj_elem_params.shape_id = "T4_T1"
            self.unhide_shape(proj_elem_params)
        except SystemError as e:
            raise SystemError(e)

    def cs_frame_hide(self):
        """Hide frame lines of user reference system.

        Raises:
            SystemError:
        """
        proj_elem_params = ProjectionElementParameters()
        proj_elem_params.group_name = self.coordinate_system + "_frame"
        proj_elem_params.shape_type = "polyline"
        
        try:
            proj_elem_params.shape_id = "T1_T2"
            self.hide_shape(proj_elem_params)
            proj_elem_params.shape_id = "T2_T3"
            self.hide_shape(proj_elem_params)
            proj_elem_params.shape_id = "T3_T4"
            self.hide_shape(proj_elem_params)
            proj_elem_params.shape_id = "T4_T1"
            self.hide_shape(proj_elem_params)
        except SystemError as e:
            raise SystemError(e)