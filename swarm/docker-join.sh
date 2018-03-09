#!/bin/bash

if [ -z "${jointoken}" ]; then
	docker swarm init
	docker service create --publish 9100:9100 --mode global --name node-exporter --mount type=bind,source=/proc,target=/host/proc --mount type=bind,source=/sys,target=/host/sys --mount type=bind,source=/,target=/rootfs --mount type=bind,source=/etc/hostname,target=/etc/host_hostname --env HOST_HOSTNAME=/etc/host_hostname --detach=true basi/node-exporter:latest --path.procfs /host/proc --path.sysfs /host/sys --collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)" --collector.textfile.directory /etc/node-exporter/
else
	docker swarm join --token "${jointoken}" "${managerip}"
fi

