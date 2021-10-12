# openwebrx-softmbe-docker
This is the docker image for [openwebrx](https://github.com/jketterl/openwebrx) with integrated mbelib via [codecserver-softmbe](https://github.com/knatterfunker/codecserver-softmbe), which enables the now-removed DMR and D-Star.

Get it from [docker hub](https://hub.docker.com/r/slechev/openwebrx-softmbe).


# INSTALL
## via docker cli
```
docker volume create openwebrx-settings
docker run --device /dev/bus/usb -p 8073:8073 -v openwebrx-settings:/var/lib/openwebrx slechev/openwebrx-softmbe:latest
```

## via portainer
first create an volume for the settings:
![volume](/portainer/add_volume.png)
