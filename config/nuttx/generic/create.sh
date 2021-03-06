#! /bin/bash

set -e
set -o nounset
set -o pipefail
export http_proxy=http://proxy-chain.intel.com:911
export https_proxy=https://proxy-chain.intel.com:911
export ftp_proxy=http://proxy-chain.intel.com:911
export socks_proxy=http://proxy-chain.intel.com:1080


[ -d $FW_TARGETDIR ] || mkdir $FW_TARGETDIR
pushd $FW_TARGETDIR >/dev/null

    vcs import --input $PREFIX/config/$RTOS/generic/uros_packages.repos

    # install uclibc
    if [ ! -d "NuttX/libs/libxx/uClibc++" ]
    then
      pushd uclibc >/dev/null
      ./install.sh ../NuttX
      popd >/dev/null
    fi

    # ignore broken packages
    touch mcu_ws/ros2/rcl_logging/rcl_logging_log4cxx/COLCON_IGNORE
    touch mcu_ws/ros2/rcl_logging/rcl_logging_spdlog/COLCON_IGNORE
    touch mcu_ws/ros2/rcl/rcl_action/COLCON_IGNORE

    touch mcu_ws/ros2/rcl/COLCON_IGNORE
    touch mcu_ws/ros2/rosidl/rosidl_typesupport_introspection_c/COLCON_IGNORE
    touch mcu_ws/ros2/rosidl/rosidl_typesupport_introspection_cpp/COLCON_IGNORE
    touch mcu_ws/ros2/rcpputils/COLCON_IGNORE
    touch mcu_ws/uros/rcl/rcl_yaml_param_parser/COLCON_IGNORE
    touch mcu_ws/uros/rclc/rclc_examples/COLCON_IGNORE

    rosdep install -y --from-paths mcu_ws -i mcu_ws --rosdistro foxy --skip-keys="$SKIP"

popd >/dev/null

cp $PREFIX/config/$RTOS/generic/package.xml $FW_TARGETDIR/apps/package.xml
rosdep install -y --from-paths $FW_TARGETDIR/apps -i $FW_TARGETDIR/apps --rosdistro foxy
