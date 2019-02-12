#!/bin/bash
TOKEN=$(curl -I -s -i -k -H "Accept:application/*+xml;version=1.5" -u $VCD_AUTH -X POST $VCD_URL/sessions |grep  auth |awk {'print $2'} |sed 's/\r$//')
echo $TOKEN > undeploy_vcd_token.txt
VAPP_URL=$(curl -s -i -k -H "Accept:application/*+xml;version=1.5" -H "x-vcloud-authorization: $TOKEN" -X GET  "$VCD_URL/query?type=vApp" |grep name=\"vApp_$VAPP_NAME\"  |grep -o "href.*" | sed 's/\s.*$//' |sed -e 's/href="//' |sed  's/"//')
echo $VAPP_URL > undeploy_vapp_url.txt
UNDEPLOY=$(curl -s -i -k -H "Accept:application/*+xml;version=1.5" -H "x-vcloud-authorization: $TOKEN" -H "Content-Type:application/vnd.vmware.vcloud.undeployVAppParams+xml" -X POST $VAPP_URL"/action/undeploy" -d "<UndeployVAppParams xmlns=\"http://www.vmware.com/vcloud/v1.5\"><UndeployPowerAction>powerOff</UndeployPowerAction></UndeployVAppParams>")
echo $UNDEPLOY > undeploy_vapp.txt
sleep 30
jq -r -n --arg vm_name "${VAPP_NAME}" --arg output  "UNDEPLOYED" '{"vm_name":$vm_name,"output":$output}'
