#!/usr/bin/env python3

import sys
# import os
# import threading
import time
import math
from zlp import ProjectorClient, CoordinateSystem, ProjectionElementControl

class ProjectorManager:
    
    def __init__(self, projector_IP = "192.168.10.10", server_IP = "192.168.10.11", connection_port = 9090):
        self.projector_IP = projector_IP
        self.server_IP = server_IP
        self.connection_port = connection_port
        # self.license_path = "/lic/1900027652.lic"
        self.projector_id = ""

        self.projector_client = ProjectorClient() 

    def client_server_connect(self):
        success,message = self.projector_client.connect(self.server_IP, self.connection_port)
        return success,message

    def client_server_disconnect(self):
        success,message = self.projector_client.disconnect()
        return success,message

    def activate(self):
        self.projector_id,success,message = self.projector_client.activate_projector(self.projector_IP)
        return success,message

    def deactivate(self):
        success,message = self.projector_client.deactivate_projector()
        return success,message

    def load_license(self,license_path):
        _,message1 = self.projector_client.transfer_license(license_path)
        success,message2 = self.projector_client.check_license()
        return success,message1,message2

    def geotree_operator_create(self):
        module_id,success,message = self.projector_client.function_module_create()
        thrift_client = self.projector_client.get_thrift_client()

        self.cs_element = CoordinateSystem(self.projector_id, module_id, thrift_client)
        self.projection_element = ProjectionElementControl(module_id,thrift_client)

        return success,message

    def start_projection(self,coord_sys):
        success,message = self.projector_client.start_project(coord_sys)
        return success,message 

    def stop_projection(self): 
        success,message = self.projector_client.stop_project()
        return success,message

    def get_coordinate_systems(self):
        cs_list,success,message = self.cs_element.coordinate_system_list()
        return cs_list,success,message

    def define_coordinate_system(self,cs_params): # cual success, message ????
        coord_sys,success,message = self.cs_element.define_cs(cs_params)

        success,message = self.set_coordinate_system(coord_sys)

        # success,message = self.register_coordinate_system(coord_sys) 
        success,message = self.cs_element.register_cs(coord_sys)

        # success,message = self.__cs_axes_create(coord_sys,cs_params)

        return coord_sys,success,message 

    def set_coordinate_system(self,coord_sys): 
        success,message = self.cs_element.set_cs(coord_sys)
        return success,message

    # SE PUEDE BORRAR register_coordinate_system???
    # def register_coordinate_system(self,coord_sys): 
    #     success,message = self.cs_element.register_cs(coord_sys)
    #     return success,message

    def show_coordinate_system(self,coord_sys,secs):
        success,message = self.cs_element.show_cs(coord_sys, secs)
        return success,message

    def remove_coordinate_system(self,coord_sys):
        success,message = self.cs_element.remove_cs(coord_sys)
        return success,message

    def create_polyline(self,coord_sys,proj_elem_params):
        success,message = self.projection_element.define_polyline(coord_sys,proj_elem_params)

        success,message = self.start_projection(coord_sys)
        time.sleep(5)
        self.stop_projection()

        return success,message

    def hide_shape(self,proj_elem_params): 
        success,message = self.projection_element.deactivate_shape(proj_elem_params)
        return success,message

    def unhide_shape(self,proj_elem_params): 
        success,message = self.projection_element.reactivate_shape(proj_elem_params)
        return success,message

    def remove_shape(self,proj_elem_params):
        success,message = self.projection_element.delete_shape(proj_elem_params)
        return success,message






    # def __cs_axes_create(self,coord_sys,cs_params):
        
    #     proj_elem_params.shape_type            = "polyline"
    #     proj_elem_params.projection_group_name = coord_sys + "_origin"
    #     proj_elem_params.shape_id              = "axis_x"
    #     proj_elem_params.x                     = cs_params.T1_x
    #     proj_elem_params.y                     = cs_params.T1_y
    #     proj_elem_params.angle                 = 0
    #     proj_elem_params.length                = 50

    #     success,message = self.projection_element.define_polyline(coord_sys, proj_elem_params) 
        
    #     proj_elem_params.shape_type            = "polyline"
    #     proj_elem_params.projection_group_name = coord_sys + "_origin"
    #     proj_elem_params.shape_id              = "axis_y"
    #     proj_elem_params.x                     = cs_params.T1_x
    #     proj_elem_params.y                     = cs_params.T1_y
    #     proj_elem_params.angle                 = 90
    #     proj_elem_params.length                = 50

    #     success,message = self.projection_element.define_polyline(coord_sys, proj_elem_params)

    #     success,message = self.start_projection(coord_sys)
    #     time.sleep(5)
    #     success,message = self.stop_projection()

    #     success,message = self.hide_shape(proj_elem_params)
    #     success,message = self.hide_shape(proj_elem_params)

    #     return success,message

    # def cs_axes_unhide(self,coord_sys):
        
    #     proj_elem_params.shape_type            = "polyline"
    #     proj_elem_params.projection_group_name = coord_sys + "_origin"
    #     proj_elem_params.shape_id              = "axis_y"
    #     success,message = self.unhide_shape(proj_elem_params)

    #     proj_elem_params.shape_type            = "polyline"
    #     proj_elem_params.projection_group_name = coord_sys + "_origin"
    #     proj_elem_params.shape_id              = "axis_y"
    #     success,message = self.unhide_shape(proj_elem_params)

    #     success,message = self.start_projection(coord_sys)
    #     time.sleep(5)
    #     success,message = self.stop_projection()

    #     success,message = self.hide_shape(proj_elem_params)
    #     success,message = self.hide_shape(proj_elem_params)

    #     return success,message