#!/bin/bash

set -o pipefail

OUTPUT=""

if [[ $IMAGE_UUID == "" ]]
then

IMAGE_UUID="$(openstack image list -f json | jq -r "map(select(.Name==\"${IMAGE}\")) | map(select(.Status==\"active\")) | .[0] | .ID | select (.!=null)")"

if [ -n "${IMAGE_UUID}" ]; then
  OUTPUT="${IMAGE} already exist, skip image upload"
else
  IMAGE_UUID=$(
  # If another upload is running wait 5 min
  IMAGE_CREATED_NEWEST_ELAPSED=0
  while [ ${IMAGE_CREATED_NEWEST_ELAPSED} -lt 300 ]; do
    [ $IMAGE_CREATED_NEWEST_ELAPSED -ne 0 ] && sleep 10
    IMAGES_SAVING_UUID="$(openstack image list -f json | jq -r "map(select(.Name==\"${IMAGE}\")) | map(select(.Status==\"saving\")) | .[].ID | select (.!=null)")"
    IMAGE_CREATED_NEWEST=0
    for IMAGE_SAVING_UUID in $IMAGES_SAVING_UUID; do
      IMAGE_CREATED=$(openstack image show -f json ${IMAGE_SAVING_UUID} | jq -r .created_at | xargs -i date "+%s" -d "{}")
      if [ ${IMAGE_CREATED} -gt ${IMAGE_CREATED_NEWEST} ]; then
        IMAGE_CREATED_NEWEST=${IMAGE_CREATED}
      fi
    done
    IMAGE_CREATED_NEWEST_ELAPSED=$(echo $(date "+%s") - ${IMAGE_CREATED_NEWEST} | bc)
    IMAGE_UUID="$(openstack image list -f json | jq -r "map(select(.Name==\"${IMAGE}\")) | map(select(.Status==\"active\")) | .[0] | .ID | select (.!=null)")"
    if [ ${IMAGE_UUID} ]; then
      echo ${IMAGE_UUID}
      exit 0
    fi
  done

  until curl -s https://swift.entercloudsuite.com/v1/KEY_1a68c22a99cd4e558054ede2c878929d/automium-catalog-images/openstack/${IMAGE}.qcow2 | openstack image create ${IMAGE} -f json >/dev/null; do
    sleep 10
    openstack image list -f json | jq -r "map(select(.Name==\"${IMAGE}\")) | map(select(.Status!=\"saving\")) | map(select(.Status!=\"active\")) | .[0] | .ID | select(.!=null)" | while read uuid; do openstack image delete $uuid > /dev/null; done
  done

  IMAGE_UUID=$(openstack image list -f json | jq -r "map(select(.Name==\"${IMAGE}\")) | map(select(.Status==\"active\")) | .[0] | .ID | select(.!=null)")
  openstack image set --property hw_vif_multiqueue_enabled='true' ${IMAGE_UUID} > /dev/null
  echo ${IMAGE_UUID}
  )
fi
fi

OUTPUT=$(echo $OUTPUT | cut -c 1-20)
jq -r -n --arg image_uuid "${IMAGE_UUID}" --arg output "${OUTPUT}" '{"image_uuid":$image_uuid,"output":$output}'