# Pull base image
FROM resin/rpi-raspbian:jessie
MAINTAINER elRadix <elRadix@gmail.com>

RUN apt-get update && apt-get install -y wget

#network tools
RUN apt-get install -y fping
RUN apt-get install -y net-tools


RUN wget -q -O - http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | apt-key add -
RUN wget -q -O /etc/apt/sources.list.d/mosquitto-jessie.list http://repo.mosquitto.org/debian/mosquitto-jessie.list
RUN apt-get update && apt-get install -y mosquitto
RUN apt-get install -y mosquitto-clients

RUN adduser --system --disabled-password --disabled-login mosquitto

COPY config /mqtt/config
VOLUME ["/mqtt/config", "/mqtt/data", "/mqtt/log", "/mqtt/scripts"]

EXPOSE 1883 8883 9001
CMD /usr/sbin/mosquitto -c /mqtt/config/mosquitto.conf
