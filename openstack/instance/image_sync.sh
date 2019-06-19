#!/bin/bash

set -o pipefail

IMAGE_UUID="$(openstack image list -f json | jq -r "map(select(.Name==\"${IMAGE}\")) | map(select(.Status==\"active\")) | .[0] | .ID | select (.!=null)")"
OUTPUT=""

if [ -n "${IMAGE_UUID}" ]; then
  OUTPUT="${IMAGE} already exist, skip image upload"
else
  OUTPUT=$(
  until curl -s https://swift.entercloudsuite.com/v1/KEY_1a68c22a99cd4e558054ede2c878929d/automium-catalog-images/openstack/${IMAGE}.qcow2 | openstack image create ${IMAGE} -f json; do
    sleep 10
    openstack image list -f json | jq -r "map(select(.Name==\"${IMAGE}\")) | map(select(.Status!=\"saving\")) | map(select(.Status!=\"active\")) | .[0] | .ID | select(.!=null)" | while read uuid; do openstack image delete $uuid; done
  done
  )
  IMAGE_UUID=$(openstack image list -f json | jq -r "map(select(.Name==\"${IMAGE}\")) | map(select(.Status==\"active\")) | .[0] | .ID | select(.!=null)")
fi

OUTPUT=$(echo $OUTPUT | cut -c 1-20)
jq -r -n --arg image_uuid "${IMAGE_UUID}" --arg output "${OUTPUT}" '{"image_uuid":$image_uuid,"output":$output}'
