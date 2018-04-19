# rpi-mosquitto

Raspberry Pi compatible Docker Image with mosquitto MQTT broker.
Based upon [docker-mosquitto](https://github.com/toke/docker-mosquitto).

## How to run

```
docker run -tip 1883:1883 -p 9001:9001 elradix/rpi-mosquitto
```

Exposes Port 1883 (MQTT) 8883 (MQTT) 9001 (Websocket MQTT)

Alternatively you can use volumes to make the changes persistent and change the configuration.
```
mkdir -p /srv/mqtt/config/
mkdir -p /srv/mqtt/data/
mkdir -p /srv/mqtt/log/
mkdir -p /srv/mqtt/scripts/

# place your mosquitto.conf in /srv/mqtt/config/
# NOTE: You have to change the permissions of the directories
# to allow the user to read/write to data and log and read from
# config directory
# For TESTING purposes you can use chmod -R 777 /srv/mqtt/*
# Better use "-u" with a valid user id on your docker host

docker run -ti -p 1883:1883 -p 8883:8883 -p 9001:9001 \
-v /srv/mqtt/config:/mqtt/config:ro \
-v /srv/mqtt/log:/mqtt/log \
-v /srv/mqtt/log:/mqtt/scripts \
-v /srv/mqtt/data/:/mqtt/data/ \
--name mqtt pascaldevink/rpi-mosquitto
```
## Start with systemd
As an example this how you run the container with systemd. The example uses a docker volume named mosquitto_data (see above).
```
[Unit]
Description=Mosquitto MQTT docker container
Requires=docker.service
Wants=docker.service
After=docker.service

[Service]
Environment=EXT_IP=123.123.123.123
Restart=always
ExecStart=/usr/bin/docker run -v /srv/mqtt/config:/mqtt/config -v /srv/mqtt/log:/mqtt/log -v mosquitto_data:/mqtt/data/ -p ${EXT_IP}:1883:1883 -p ${EXT_IP}:8883:8883 -p 127.0.0.1:9001:9001 --name mqtt elradix/rpi-mosquitto
ExecStop=/usr/bin/docker stop -t 2 mqtt
ExecStopPost=/usr/bin/docker rm -f mqtt

[Install]
WantedBy=local.target
```
## How to create this image

Run all the commands from within the project root directory.

### Build the Docker Image
```bash
make build
```

#### Push the Docker Image to the Docker Hub
* First use a `docker login` with username, password and email address
* Second push the Docker Image to the official Docker Hub

```bash
make push
```

## License

The MIT License (MIT)

Copyright (c) 2015 Pascal de Vink

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
