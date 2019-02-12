#!/bin/bash
TOKEN=$(curl -I -s -i -k -H "Accept:application/*+xml;version=1.5" -u "$VCD_AUTH" -X POST "$VCD_URL"sessions |grep  auth |awk {'print $2'} |sed 's/\r$//')
echo $TOKEN > vcd_token.txt
VAPP_URL=$(curl -s -i -k -H "Accept:application/*+xml;version=1.5" -H "x-vcloud-authorization: $TOKEN" -X GET  "$VCD_URL/query?type=vApp" |grep name=\"vApp_$VAPP_NAME\"  |grep -o "href.*" | sed 's/\s.*$//' |sed -e 's/href="//' |sed  's/"//')
echo $VAPP_URL > vcd_poweron_url.txt
POWERON=$(curl -s -i -k -H "Accept:application/*+xml;version=1.5" -H "x-vcloud-authorization: $TOKEN" -X POST $VAPP_URL"/power/action/"$ACTION)
echo $POWERON > vcd_poweron.txt
jq -r -n --arg vm_name "${VAPP_NAME}" --arg output  "${ACTION}" '{"vm_name":$vm_name,"output":$output}'
