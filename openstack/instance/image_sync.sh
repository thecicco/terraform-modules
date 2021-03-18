#!/bin/bash

set -o pipefail

TIMEOUT=2700

checksum() {
  if [ -z ${IMAGE_UUID} ]; then
    return
  fi
  IMAGE_CHECKSUM=$(openstack image show -f json $IMAGE_UUID  | jq -r '.checksum')
  IMAGE_REMOTE_CHECKSUM=$(curl -s https://swift.entercloudsuite.com/v1/KEY_1a68c22a99cd4e558054ede2c878929d/automium-catalog-images/openstack/${IMAGE}.qcow2.md5sum)
  # Check that is not an empty string and that is a md5 like string
  if [ "${IMAGE_REMOTE_CHECKSUM}" ] && \
     [ "$(echo ${IMAGE_REMOTE_CHECKSUM} | wc -m)" == "33" ]; then
    if [ "${IMAGE_CHECKSUM}" != "${IMAGE_REMOTE_CHECKSUM}" ]; then
      >&2 echo "Checksum of the image ${IMAGE} is not consistent"
      openstack image delete ${IMAGE_UUID}
      IMAGE_UUID=""
    else
      >&2 echo "Checksum of the image ${IMAGE} is valid"
    fi
  fi
}


while [ -z "${IMAGE_UUID}" ]; do
  IMAGE_UUID="$(openstack image list -f json | jq -r "map(select(.Name==\"${IMAGE}\")) | map(select(.Status==\"active\")) | .[0] | .ID | select (.!=null)")"
  OUTPUT=""

  if [ -n "${IMAGE_UUID}" ]; then
    OUTPUT="${IMAGE} already exist, skip image upload"
    checksum
  else
    IMAGE_UUID=$(
    >&2 echo "Starting image check for ${IMAGE}"

    # TODO: Replace it with a file lock when we have shared volume between jobs
    # In case of multiple run, try to avoid multiple image upload
    sleep $(($(shuf -i 0-5 -n 1) * 7))

    # If another upload is running wait 5 min
    IMAGE_CREATED_NEWEST_ELAPSED=0
    while [ ${IMAGE_CREATED_NEWEST_ELAPSED} -lt ${TIMEOUT} ]; do
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
      checksum
      if [ ${IMAGE_UUID} ]; then
        echo ${IMAGE_UUID}
        exit 0
      fi
    done

    >&2 echo "Starting image upload"
    COUNT=0
    until timeout ${TIMEOUT} curl -s https://swift.entercloudsuite.com/v1/KEY_1a68c22a99cd4e558054ede2c878929d/automium-catalog-images/openstack/${IMAGE}.qcow2 | openstack image create ${IMAGE} -f json >/dev/null; do
      let COUNT++
      sleep 10
      openstack image list -f json | jq -r "map(select(.Name==\"${IMAGE}\")) | map(select(.Status!=\"saving\")) | map(select(.Status!=\"active\")) | .[0] | .ID | select(.!=null)" | while read uuid; do openstack image delete $uuid > /dev/null; done
      if COUNT > 5; then
        >&2 echo 'Number of retry exceeded ($COUNT) during image upload ${IMAGE} - retrying from start'
        continue
      fi
    done

    IMAGE_UUID=$(openstack image list -f json | jq -r "map(select(.Name==\"${IMAGE}\")) | map(select(.Status==\"active\")) | .[0] | .ID | select(.!=null)")
    openstack image set --property hw_vif_multiqueue_enabled='true' ${IMAGE_UUID} > /dev/null

    checksum

    echo ${IMAGE_UUID}
    )
  fi
done


OUTPUT=$(echo $OUTPUT | cut -c 1-20)
jq -r -n --arg image_uuid "${IMAGE_UUID}" --arg output "${OUTPUT}" '{"image_uuid":$image_uuid,"output":$output}'