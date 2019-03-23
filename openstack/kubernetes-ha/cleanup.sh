#!/bin/bash

set -x

function node_exist() {
  curl -s "http://${consul}:${consul_port}/v1/agent/members" | jq '.[] | select(.Name=="${name}")'
}

while [ "$(node_exist)" ]; do
  echo deregister node from consul
  curl -sS -X PUT "http://${consul}:${consul_port}/v1/agent/force-leave/${name}-$${_NUMBER}"
  curl -sS -X PUT "http://${consul}:${consul_port}/v1/catalog/deregister?dc=${consul_datacenter}" --data \{\"Datacenter\":\"${consul_datacenter}\",\"Node\":\"${name}-$${_NUMBER}\"\} > /dev/null
  sleep 1
done

if [ "${quantity}" = "0" ]; then
  echo "is the last node so clean up everything"
  # remove consul keys
  curl -sS -X DELETE "http://${consul}:${consul_port}/v1/kv/kubernetes/master/${name}?recurse=yes"
fi

exit 0
