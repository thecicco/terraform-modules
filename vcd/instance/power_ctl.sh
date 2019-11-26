#!/bin/bash
vcd login $VCD_URL $VCD_ORG $VCD_USERNAME > /dev/null
POWERON=$(vcd vapp power-on $VAPP_NAME $VM)
jq -r -n --arg vm_name "${VM_NAME}" --arg vapp_name "${VAPP_NAME}" --arg output "${POWERON}" '{"vm_name":$vm_name,"vapp_name":$vapp_name,"output":$output}'
