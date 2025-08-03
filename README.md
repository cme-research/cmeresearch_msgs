# CME Research Messages

This ROS package contains custom message definitions used in CME Research projects.

## Package Overview

This package provides standardized message definitions that facilitate communication between different ROS nodes in CME Research projects. The messages are defined in the `msg` directory and are automatically generated into language-specific implementations during the build process.


# ROS Distro Support #


|         |                                         melodic                                          |      noetic      |                                        rolling                                        |
|:-------:|:----------------------------------------------------------------------------------------:|:----------------:|:-------------------------------------------------------------------------------------:|
| Branch  | |                  | [`rolling_dev`](https://bitbucket.org/cme-robotics/cmeresearch_msgs/src/rolling_dev/) |
| Status  |                                      not supported                                       |  not supported   |                                       supported                                       |
| Version |                                     no yet released                                      | not yet released |                                   not yet released                                    |




## Getting Started

### Prerequisites

* ROS (Robot Operating System)
* CMake
* catkin build system

### Installation

1. Clone this repository into your catkin workspace's `src` directory:
   ```bash
   cd ~/catkin_ws/src
   git clone <repository-url>
   ```

2. Build the package:
   ```bash
   cd ~/catkin_ws
   catkin build cmeresearch_msgs
   ```

3. Source your workspace:
   ```bash
   source ~/catkin_ws/devel/setup.bash
   ```

## Usage

To use these messages in your ROS nodes, add `cmeresearch_msgs` as a dependency in your package's `package.xml` and `CMakeLists.txt` files.

## Contact

For more information, please contact:
- Email: info@cme-robotics.com
- Website: https://cme-robotics.com