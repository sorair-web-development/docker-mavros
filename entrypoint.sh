#!/bin/bash

FCUURL=$1

printf "Delaying start for $STARTDELAY seconds\n"
sleep $STARTDELAY

source /opt/ros/kinetic/setup.bash
roscd mavros
roslaunch mavros apm2.launch fcu_url:=${FCUURL}
