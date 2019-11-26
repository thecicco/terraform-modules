#!/bin/bash

set -e
set -x

if [ "${DISK_SIZE}" == "" ]; then
  exit 0
fi

export VCD_AUTH="${VCD_USERNAME}@${VCD_ORG}:${VCD_PASSWORD}"
export RESULT="ok"

TOKEN=$(curl -f -I -s -i -k -H "Accept:application/*+xml;version=1.5" -u "$VCD_AUTH" -X POST "$VCD_URL/api/sessions" |grep  auth |awk {'print $2'} |sed 's/\r$//')

VM_HREF=$(curl -f -s -H "Accept:application/*+xml;version=1.5" -H "x-vcloud-authorization: $TOKEN" -X GET "$VCD_URL/api/query?type=vm&filter=(name==$VM)" | xq -r '.QueryResultRecords.VMRecord["@href"]')

DISK_SIZE_CURRENT=$(curl -f -s -H "Accept:application/*+xml;version=1.5" -H "x-vcloud-authorization: $TOKEN" -X GET ${VM_HREF}/virtualHardwareSection/disks | xq -r '.RasdItemsList.Item[1]["rasd:HostResource"]["@ns13:capacity"]')

if [ "$DISK_SIZE_CURRENT" == "$DISK_SIZE" ]; then
  # Do nothing
  RESULT="ok"
else
  RESULT="changed"

  DISK_RESIZE_REQ=$(curl -f -s -H "Accept:application/*+xml;version=1.5" -H "x-vcloud-authorization: $TOKEN" -X GET ${VM_HREF}/virtualHardwareSection/disks | xq -x --arg DISK_SIZE "$DISK_SIZE" '.RasdItemsList.Item[1]["rasd:HostResource"]["@ns13:capacity"] = $DISK_SIZE')

  DISK_RESIZE_TASK_HREF=$(curl -f -s -H "Accept:application/*+xml;version=1.5" -H "x-vcloud-authorization: $TOKEN" -X PUT ${VM_HREF}/virtualHardwareSection/disks -H "Content-Type: application/vnd.vmware.vcloud.rasdItemsList+xml" -d "${DISK_RESIZE_REQ}" | xq -r '.Task["@href"]')

  get_task_status() {
    curl -f -s -H "Accept:application/*+xml;version=1.5" -H "x-vcloud-authorization: $TOKEN" -X GET "${1}" | xq -r '.Task["@status"]'
  }

  DISK_RESIZE_TASK_STATUS=$(get_task_status ${DISK_RESIZE_TASK_HREF})

  # Wait until task is completed
  while [ ${DISK_RESIZE_TASK_STATUS} != "success" ] &&
        [ ${DISK_RESIZE_TASK_STATUS} != "error" ] &&
        [ ${DISK_RESIZE_TASK_STATUS} != "aborted" ]; do

    if [ ${DISK_RESIZE_TASK_STATUS} == "error" ] ||
       [ ${DISK_RESIZE_TASK_STATUS} == "aborted" ]; then
      echo [${DISK_RESIZE_TASK_HREF}] task ${DISK_RESIZE_TASK_STATUS}, exiting
      exit 1
    fi

    DISK_RESIZE_TASK_STATUS=$(get_task_status ${DISK_RESIZE_TASK_HREF})
    sleep 0.4
  done
fi

jq -r -n --arg vm "${VM}" --arg disk_size "${DISK_SIZE}" --arg result "${RESULT}" '{"vm":$vm,"disk_size":$disk_size,"result":$result}'
