#!/bin/bash

if [ -z "${jointoken}" ]; then
	docker swarm init
else
	docker swarm join --token "${jointoken}" "${managerip}"
fi

