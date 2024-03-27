FROM ros:kinetic
LABEL maintainer adebayo@sorair.co.uk

# Trick to get apt-get to not prompt for timezone in tzdata
ENV DEBIAN_FRONTEND=noninteractive

ARG STARTDELAY=5
ENV STARTDELAY=$STARTDELAY

# Install MAVROS and some other dependencies for later
RUN apt-get update && apt-get install -y ros-kinetic-mavros ros-kinetic-mavros-extras ros-kinetic-mavros-msgs vim wget screen

# Dependency from https://github.com/mavlink/mavros/blob/master/mavros/README.md
RUN wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh
RUN chmod +x install_geographiclib_datasets.sh
RUN ./install_geographiclib_datasets.sh

# Fix the broken apm_config.yaml
COPY apm_config.yaml /opt/ros/kinetic/share/mavros/launch/apm_config.yaml

# MAVLink Input
EXPOSE 5760

# Envs
ENV FCUURL=tcp://localhost:5760

# Finally the command
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh ${FCUURL}


# docker buildx build --platform linux/arm64,linux/amd64 -t adebayost/mavros:latest --push .

# docker run -it --rm -p 5761:5760 \
#    --env VEHICLE=APMrover2 \
#    --env LAT=39.9656 \
#    --env LON=-75.1810 \
#    --env ALT=276 \
#    --env DIR=180 \
#    --env SPEEDUP=2 \
#    adebayost/ardupilot-sitl

# docker run -it --rm --env FCUURL="tcp://localhost:5760" radarku/mavros