# openwebrx-softmbe-docker
This is the docker image for [openwebrx](https://github.com/jketterl/openwebrx) with integrated mbelib via [codecserver-softmbe](https://github.com/knatterfunker/codecserver-softmbe), which enables the now-removed DMR and D-Star.

Get it from [docker hub](https://hub.docker.com/r/slechev/openwebrx-softmbe).


## first disable the kernel driver for RTL devices (if you're going to use one) and then reboot
```
echo 'blacklist dvb_usb_rtl28xxu' > /etc/modprobe.d/rtl28xx-blacklist.conf
reboot
```

## read how to run the docker image
[on the official wiki](https://github.com/jketterl/openwebrx/wiki/Getting-Started-using-Docker)

## install via docker cli
```
docker volume create openwebrx-settings
docker volume create openwebrx-etc
docker run --name openwebrx-softmbe --device /dev/bus/usb -p 8073:8073 -v openwebrx-settings:/var/lib/openwebrx -v openwebrx-etc:/etc/openwebrx --restart unless-stopped slechev/openwebrx-softmbe
```

## create admin user
[follow official wiki](https://github.com/jketterl/openwebrx/wiki/User-Management#special-information-for-docker-users)


## install via portainer
first create a volume for the settings:

![volume](/portainer/add_volume.png)

then create new container:
- name: `openwebrx-softmbe`
- image: `slechev/openwebrx-softmbe:latest`
- click on __publish a new network port__ and fill _host_ and _container_ with `8073`

![container1](/portainer/container_1.png)


then in __advanced settings__ do the following:  

in the __command & logging__ tab:
- on __entrypoint__ click __override__ and type `/init`
- in __working dir__ type `/opt/openwebrx`

![container2](/portainer/container_2.png)

in __volumes__ tab:
- click __map additional volume__
- in _container_ type `/var/lib/openwebrx`
- in _volume_ select the volume that has been created in the first step (`openwebrx-settings`)

![container3](/portainer/container_3.png)

in __env__ tab:
- click __add new environment variable__
- for _name_ type `PATH` and for _value_ type `/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin` (this is probably the default and not needed)
- click again on __add new environment variable__
- for _name_ type `S6_CMD_ARG0` and for _value_ type `/opt/openwebrx/docker/scripts/run.sh` (this is important)

![container4](/portainer/container_4.png)

in __restart policy__ tab:
- select __unless stopped__ (I prefer it this way)

![container5](/portainer/container_5.png)

in __runtime & resources__ (_very important_)
- click on __add device__
- for both _host_ and _container_ type `/dev/bus/usb` (to allow access for the container to the usb dongle)

![container6](/portainer/container_6.png)
