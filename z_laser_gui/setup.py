from distutils.core import setup
from catkin_pkg.python_setup import generate_distutils_setup

setup_args = generate_distutils_setup(
    packages=['z_laser_gui'],
    package_dir={'': 'src'},
)
 
setup(**setup_args)